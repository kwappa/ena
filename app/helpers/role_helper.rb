module RoleHelper
  def candidate_roles(team, operator, candidate_member)
    operator.assignable_team_member_roles(team) - candidate_member.roles(team)
  end
end
