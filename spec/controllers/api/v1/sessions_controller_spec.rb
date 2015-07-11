require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user){create(:user)}

    context 'on success' do
      let(:credentials){{email: user.email, password: user.password}}
      before(:each) do
        post :create, {session: credentials}
      end

      it 'returns the user record corresponding to the given credentials' do
        user.reload
        expect(json_response[:auth_token]).to eq(user.auth_token)
      end
      it {should respond_with 200}
    end

    context 'on failure' do
      let(:credentials){{email: user.email, password: "wrongpassword"}}
      before(:each) do
        post :create, {session: credentials}
      end
      it 'returns a json with an error' do
        expect(json_response[:errors]).to eq("Invalid email or password")
      end
      it {should respond_with 422}
    end
  end

end
