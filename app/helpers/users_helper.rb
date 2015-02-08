module UsersHelper
  def assigned_teams(user)
    user.assignments.includes(:team).order(:assigned_on).reverse_order.
      each_with_object({}) do |assignment, teams|
      team = assignment.team
      if teams[team.id].present?
        teams[team.id].roles.push(assignment.role.to_s.capitalize)
        teams[team.id].active ||= assignment.active?
      else
        teams[team.id] = OpenStruct.new(
          id: team.id,
          name: team.name,
          active: assignment.active?,
          roles: [assignment.role.to_s.capitalize],
        )
      end
    end
  end
end
