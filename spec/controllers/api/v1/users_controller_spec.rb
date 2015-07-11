require 'rails_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    let(:user){ FactoryGirl.create :user }

    before(:each) do
      get :show, id: user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(user.email)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when resource is successfully created' do
      let(:attributes){attributes_for(:user)}

      before(:each) do
        post :create, {user: attributes}, format: :json
      end

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(attributes[:email])
      end
      it {should respond_with 201}
    end

    context 'when resource is not created' do
      let(:attributes){attributes_for(:user, email: nil)}

      before(:each) do
        post :create, {user: attributes}, format: :json
      end

      it 'renders an error json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it 'renders json with reason of failure' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end
      it {should respond_with 422}
    end

  end
end
