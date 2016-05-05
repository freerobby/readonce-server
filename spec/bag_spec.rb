require_relative '../bag'

require 'spec_helper'

RSpec.describe Bag do
  describe '#initialize' do
    it 'adds new object to the global hash' do
      b = Bag.new
      expect(Bag.class_variable_get(:@@bags)[b.key]).to equal(b)
    end
  end

  describe '#self.find_by_key' do
    it 'loads object from key' do
      b = Bag.new
      expect(Bag.find_by_key(b.key)).to equal(b)
    end
  end

  describe '#self.delete_by_key' do
    it 'deletes object from the global hash' do
      b = Bag.new
      expect(Bag.class_variable_get(:@@bags)[b.key]).to equal(b)
      Bag.delete_by_key(b.key)
      expect(Bag.class_variable_get(:@@bags)[b.key]).to be_nil
    end
  end
end
