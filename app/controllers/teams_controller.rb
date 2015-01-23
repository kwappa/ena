class TeamsController < ApplicationController
  before_action :prepare_team, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @team = Team.new
  end

  def create
    team = Team.new(team_params)
    if team.valid?
      team.save!
      redirect_to teams_path
    else
      flash[:error] = team.errors.map { |k, v| "#{k} #{v}" }.join("\n")
      redirect_to new_team_path
    end
  end

  def edit
  end

  def update
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
end
