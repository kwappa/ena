module Occupation
  NAMES = [
    :general,
    :engineer,
    :designer,
    :director,
  ].freeze

  def self.id(name)
    NAMES.index(name) or raise(ArgumentError.new("occupation name [#{name}] does not found."))
  end

  def self.name(id)
    NAMES.fetch(id, nil) or raise(ArgumentError.new("occupation id [#{id}] does not found."))
  end
end
