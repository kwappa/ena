module Authority
  NAMES = [
    :working,                   # 0 : for member
    :leading,                   # 1 : for leader
    :management,                # 2 : for manager
    :direction,                 # 3 : for director
    :administration,            # 4 : for administrator
  ]

  def self.id(name)
    NAMES.index(name) or raise(ArgumentError.new("authority name [#{name}] does not found."))
  end

  def self.name(id)
    NAMES.fetch(id, nil) or raise(ArgumentError.new("authority id [#{id}] does not found."))
  end

  module User
    def authorize(authority_name)
      self.update(authority_id: Authority.id(authority_name))
    end

    def authority
      Authority.name(self.authority_id)
    end
  end
end
