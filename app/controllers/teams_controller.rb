class TeamsController < ApplicationController
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

  def team_params
    params.require(:team).permit(:name, :description, :disbanded_on)
  end
end
