module Role
  NAMES = [
    :member,                    # 0
    :leader,                    # 1
    :manager,                   # 2
    :director,                  # 3
  ]

  def self.id(name)
    NAMES.index(name) or raise(ArgumentError.new("role name [#{name}] does not found."))
  end

  def self.name(id)
    NAMES.fetch(id, nil) or raise(ArgumentError.new("role id [#{id}] does not found."))
  end
end
