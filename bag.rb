class Bag
  @@bags = {}

  attr_accessor :data
  attr_reader :key
  attr_accessor :accessed_at
  attr_accessor :accessed_by_ip

  def initialize
    @key = SecureRandom.hex
    @@bags[@key] = self
  end

  def self.find_by_key(key)
    @@bags[key]
  end

  def self.delete_by_key(key)
    @@bags.delete(key)
  end
end
