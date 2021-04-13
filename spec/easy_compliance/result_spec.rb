require 'spec_helper'

describe EasyCompliance::Result do
  describe '#hit?' do
    it 'is true for status 200' do
      expect(EasyCompliance::Result.new(status: 200)).to be_hit
      expect(EasyCompliance::Result.new(status: 204)).not_to be_hit
    end
  end
end
