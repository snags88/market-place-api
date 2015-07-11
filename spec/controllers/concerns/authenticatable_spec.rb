require 'rails_helper'

class Authentication
  attr_accessor :request
  include Authenticatable
end

describe Authenticatable do
  let(:authentication) {Authentication.new}

  describe '#current_user' do
    let(:user){create(:user)}
    before do
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request) {request}
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user).to eq(user)
    end
  end
end
