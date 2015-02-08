class TeamsController < ApplicationController
  include AuthorityHelper
  include RoleHelper

  TEAMS_PER_PAGE = 10

  before_action :authenticate_user!, only: [:search_candidate_member, :update]
  before_action :prepare_team, only: [:show, :edit, :update, :destroy, :search_candidate_member]
  before_action :authorize_team_create, only: [:new, :create]
  before_action :authorize_assign_member, only: [:search_candidate_member]

  def index
    @teams = Team.page(params[:page]).per(TEAMS_PER_PAGE)
  end

  def new
    @team = Team.new
  end

  def show
  end

  def create
    @team = Team.new(team_detail_params)
    validate_and_save_team
  end

  def edit
  end

  def update
    unless @team.description_editable?(current_user)
      flash[:warning] = "You don't have a permission to update this team."
      redirect_to team_path(@team) and return
    end

    if @team.detail_editable?(current_user)
      @team.assign_attributes(team_detail_params)
    else
      @team.assign_attributes(team_description_params)
    end
    validate_and_save_team
  end

  def search_candidate_member
    name_or_nick = params[:name_or_nick]
    if name_or_nick.blank?
      flash[:warning] = "name or nick must be present."
      redirect_to(team_path(@team.id)) and return
    end

    @candidate_members = User.search_by_name_or_nick(name_or_nick)
    if @candidate_members.empty?
      flash[:warning] = "[#{name_or_nick}] does not found on any user's name or nick."
      redirect_to(team_path(@team.id)) and return
    end
  end

  def assign_member
    team             = Team.find(params[:team_id])
    operator         = User.find(params[:operator_id])
    candidate_member = User.find(params[:candidate_member_id])
    role             = params[:role].to_sym

    raise unless team.assignable?(operator, role)

    team.assign_member(candidate_member, role)
    flash[:notice] = "user [#{candidate_member.nick}] is assigned to [#{team.name}] as [#{role.to_s.capitalize}]."

    redirect_to team_path(team)
  rescue
    flash[:error] = 'failed to assign member.'
    redirect_to teams_path
  end

  private

  def team_detail_params
    params.require(:team).permit(:name, :description, :organized_on, :disbanded_on)
  end

  def team_description_params
    params.require(:team).permit(:description)
  end

  def prepare_team
    begin
      @team = Team.find(params[:id] || params[:team_id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Team does not exist.'
      redirect_to teams_path and return
    end
  end

  def validate_and_save_team
    if @team.valid?
      flash_msg = if @team.persisted?
                    "Team '#{@team.name}' is updated."
                  else
                    "Team '#{@team.name}' is created"
                  end

      @team.save!
      flash[:notice] = flash_msg
      redirect_to team_path(@team)
    else
      flash[:error] = @team.errors.map { |k, v| "#{k} #{v}" }.join("\n")
      if @team.persisted?
        redirect_to edit_team_path(@team)
      else
        redirect_to new_team_path
      end
    end
  end

  def authorize_team_create
    unless permitted_user?(:team_create)
      flash[:warning] = "you don't have permission to create new team."
      redirect_to teams_path
    end
  end

  def authorize_assign_member
    unless @team.assignable?(current_user, :member)
      flash[:warning] = "you don't have permission to assign members to this team."
      redirect_to team_path(@team)
    end
  end
end
