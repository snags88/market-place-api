require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe "GET #show" do
    let(:user){ FactoryGirl.create :user }

    before(:each) do
      get :show, id: user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eq(user.email)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when resource is successfully created' do
      let(:attributes){attributes_for(:user)}

      before(:each) do
        post :create, {user: attributes}
      end

      it 'renders the json representation for the user record just created' do
        user_response = json_response
        expect(user_response[:email]).to eq(attributes[:email])
      end
      it {should respond_with 201}
    end

    context 'when resource is not created' do
      let(:attributes){attributes_for(:user, email: nil)}

      before(:each) do
        post :create, {user: attributes}
      end

      it 'renders an error json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end
      it 'renders json with reason of failure' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include("can't be blank")
      end
      it {should respond_with 422}
    end
  end

  describe 'PUT/PATCH #update' do
    let!(:user) {create(:user)}
    context 'successful' do
      before(:each) do
        api_authorization_header(user.auth_token)
        patch :update, {id: user.id, user: { email: "newmail@test.com"}}
      end

      it 'renders the updated user json' do
        user_response = json_response
        expect(user_response[:email]).to eq("newmail@test.com")
      end
      it {should respond_with 200}
    end
    context 'unsuccessful' do
      before(:each) do
        api_authorization_header(user.auth_token)
        patch :update, { id: user.id, user: { email: "bademail.com" } }
      end

      it 'renders an error json' do
        user_response = json_response
        expect(user_response). to have_key(:errors)
      end
      it 'renders json with reason of failure' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end
      it {should respond_with 422}
    end
  end

  describe 'DELETE #destroy' do
    let!(:user){create(:user)}
    context 'successful' do
      before(:each) do
        api_authorization_header(user.auth_token)
        delete :destroy, { id: user.id}
      end

      it 'destroys the resource' do
        expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
      it {should respond_with 204}
    end
  end
end
