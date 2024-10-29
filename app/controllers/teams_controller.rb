class TeamsController < ApplicationController
  def create
    team = Team.new(team_params)

    if team.save
      render json: { message: "Team created successfully", team: team }, status: :created
    else
      render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :email, :password)
  end
end
