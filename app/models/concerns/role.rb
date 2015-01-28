module Role
  NAMES = [
    :member,                    # 0
    :leader,                    # 1
    :manager,                   # 2
    :director,                  # 3
  ]

  PERMISSIONS = {
    team_assign: {
      director: [:member, :leader, :manager],
      manager:  [:member, :leader],
      leader:   [:member],
      member:   [],
    },
  }

  def self.id(name)
    NAMES.index(name) or raise(ArgumentError.new("role name [#{name}] does not found."))
  end

  def self.name(id)
    NAMES.fetch(id, nil) or raise(ArgumentError.new("role id [#{id}] does not found."))
  end

  def self.permissions(action, role)
    PERMISSIONS.fetch(action).fetch(role)
  rescue
    raise ArgumentError.new("action #{action} or role #{role} does not found.")
  end

  module User
    def roles(team)
      self.assignments.where(team_id: team.id).pluck(:role_id).uniq.map { |role_id| Role.name(role_id) }
    end
  end

  module Team
    def assignable?(operator, role)
      return true if operator.permitted?(:team_assign)
      return false unless self.users.include?(operator)
    end

    def assign_user(user, role, assigned_on = Date.today)
      ::Assignment.create!(team_id: self.id, user_id: user.id, role_id: Role.id(role), assigned_on: assigned_on)
    end
  end
end
