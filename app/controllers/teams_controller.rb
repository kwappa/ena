class TeamsController < ApplicationController
  include AuthorityHelper

  TEAMS_PER_PAGE = 10

  before_action :prepare_team, only: [:show, :edit, :update, :destroy]
  before_action :authorize_team_create, only: [:new, :create]

  def index
    @teams = Team.page(params[:page]).per(TEAMS_PER_PAGE)
  end

  def new
    @team = Team.new
  end

  def show
  end

  def create
    @team = Team.new(team_params)
    validate_and_save_team
  end

  def edit
  end

  def update
    @team.assign_attributes(team_params)
    validate_and_save_team
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :disbanded_on)
  end

  def prepare_team
    begin
      @team = Team.find(params[:id])
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
end
