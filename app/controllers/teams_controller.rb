class TeamsController < ApplicationController
  TEAMS_PER_PAGE = 10

  before_action :prepare_team, only: [:show, :edit, :update, :destroy]

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
      @team.save!
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
end
