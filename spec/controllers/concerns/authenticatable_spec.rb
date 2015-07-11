require 'rails_helper'

class Authentication < ApiController
  include Authenticatable
end

describe Authenticatable do
  let(:authentication) {Authentication.new}
  let(:user){create(:user)}
  describe '#current_user' do
    before do
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request) {request}
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user).to eq(user)
    end
  end

  describe '#authenticate_with_token' do
    before(:each) do
      allow(authentication).to receive(:current_user){nil}
      allow(response).to receive(:response_code){401}
      allow(response).to receive(:body) do
        {"errors" => "Not authenticated"}.to_json
      end
      allow(authentication).to receive(:response){response}
    end

    xit 'renders a json error message' do
      expect(json_response[:errors]).to eq("Not authenticated")
    end

    xit 'responds with 401' do
      should respond_with 401
    end
  end

end
