require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user){create(:user)}
  describe 'user validation' do
    it 'initializes with factory' do
      expect{create(:user)}.to_not raise_error
    end
    it 'has unique tokens' do
      should validate_uniqueness_of(:auth_token)
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token) {"auniquetoken123"}
      # Devise.stub(:friendly_token).and_return()
      user.generate_authentication_token!
      expect(user.auth_token).to eq("auniquetoken123")
    end
    it 'generates another token when one is already taken' do
      existing_user = create(:user, auth_token: "auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).to_not eq("auniquetoken123")
    end
  end
end
