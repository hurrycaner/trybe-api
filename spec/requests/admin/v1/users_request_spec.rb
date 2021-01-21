require 'rails_helper'

RSpec.describe 'Admin::V1::Users', type: :request do
  let!(:user) { create(:user) }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 3) }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns all Users' do
      # add the current user to the users list to make sure all users are returned
      users << user
      expect(json_body['users']).to contain_exactly(*users.as_json(only: %i[id name image email profile]))
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'GET /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns the requested User' do
      expected_user = user.as_json(only: %i[id name image email profile])
      expect(json_body['user']).to eq expected_user
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }

    context 'with valid params' do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it 'adds a new User' do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to change(User, :count).by(1)
      end

      it 'returns last added User' do
        post url, headers: auth_header(user), params: user_params
        expected_user = User.last.as_json(only: %i[id name image email profile])
        expect(json_body['user']).to eq expected_user
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_user_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not add a new User' do
        expect do
          post url, headers: auth_header(user), params: invalid_user_params
        end.to_not change(User, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: invalid_user_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
