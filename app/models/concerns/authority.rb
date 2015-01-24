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

  module User
    def authorize(authority_name)
      self.update(authority_id: Authority.id(authority_name))
    end
  end
end
