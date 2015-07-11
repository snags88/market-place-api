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

  describe 'DELETE #destroy' do
    let(:user){create(:user)}

    before(:each) do
      sign_in(user)
    end
    let!(:original_auth_token){user.auth_token}

    it 'changes the user auth_token' do
      delete :destroy, id: user.auth_token
      user.reload
      expect(user.auth_token).to_not eq(original_auth_token)
    end

    it 'responds with the correct status' do
      delete :destroy, id: user.auth_token
      should respond_with 204
    end
  end

end
