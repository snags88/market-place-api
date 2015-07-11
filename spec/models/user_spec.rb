require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user validation' do
    it 'initializes with factory' do
      expect{create(:user)}.to_not raise_error
    end
  end
end
