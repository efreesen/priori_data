class MockedActiveRecord
  def self.all
    self
  end

  def self.where(args)
    self
  end

  def self.first_or_initialize
    self.new
  end

  def update_attributes(args)
    self
  end
end