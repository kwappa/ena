module Role
  NAMES = [
    :member,                    # 0
    :leader,                    # 1
    :manager,                   # 2
    :director,                  # 3
  ].freeze

  PERMISSIONS = {
    team_assign: {
      director: [:member, :leader, :manager],
      manager:  [:member, :leader],
      leader:   [:member],
      member:   [],
    },
  }.freeze

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

  def self.names
    NAMES.reverse
  end

  module User
    def roles(team)
      self.assignments.where(team_id: team.id).pluck(:role_id).uniq.map { |role_id| Role.name(role_id) }
    end
  end

  module Team
    def assignable?(operator, role)
      return false unless operator.present?
      return true if operator.permitted?(:team_assign)
      return false unless self.users.include?(operator)
      operator.roles(self).each do |operator_role|
        return true if ::Role.permissions(:team_assign, operator_role).include?(role)
      end
      false
    end

    def assign_member(user, role, assigned_on = Date.today)
      assign = ::Assignment.active.find_or_initialize_by(team_id: self.id, user_id: user.id, role_id: Role.id(role))
      if assign.new_record?
        assign.assigned_on = assigned_on
        assign.save!
      end

      assign
    end

    def withdraw_member(user, role, withdrawn_on = Date.today)
      assign = ::Assignment.where(team_id: self.id, user_id: user.id, role_id: Role.id(role)).active.first
      raise ActiveRecord::RecordNotFound unless assign.present?
      assign.update(withdrawn_on: withdrawn_on)
    end

    def members
      result = Role.names.each_with_object({}) { |name, r| r[name] = [] }
      self.active_users.each do |active_user|
        active_user.roles(self).each do |role|
          result[role].push(active_user)
        end
      end

      result
    end
  end
end
