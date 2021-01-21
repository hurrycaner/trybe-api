require 'rails_helper'

RSpec.describe 'Admin::V1::Users', type: :request do
  let!(:login_user) { create(:user) }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 10) }
    before(:each) { get url, headers: auth_header(login_user) }

    it 'returns all Users' do
      # add the current user to the users list to make sure all users are returned
      users << login_user
      expect(json_body['users']).to contain_exactly(*users.as_json(only: %i[id name image email profile]))
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'GET /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { get url, headers: auth_header(login_user) }

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
          post url, headers: auth_header(login_user), params: user_params
        end.to change(User, :count).by(1)
      end

      it 'returns last added User' do
        post url, headers: auth_header(login_user), params: user_params
        expected_user = User.last.as_json(only: %i[id name image email profile])
        expect(json_body['user']).to eq expected_user
      end

      it 'returns success status' do
        post url, headers: auth_header(login_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_user_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not add a new User' do
        expect do
          post url, headers: auth_header(login_user), params: invalid_user_params
        end.to_not change(User, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(login_user), params: invalid_user_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(login_user), params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context 'with valid params' do
      let(:new_name) { 'My new User' }
      let(:user_params) { { user: { name: new_name } }.to_json }
      before(:each) { patch url, headers: auth_header(login_user), params: user_params }

      it 'updates User' do
        user.reload
        expect(user.name).to eq new_name
      end

      it 'returns updated User' do
        user.reload
        expected_user = user.as_json(
          only: %i[id name email image profile]
        )
        expect(json_body['user']).to eq expected_user
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_user_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not update User' do
        old_name = user.name
        patch url, headers: auth_header(login_user), params: invalid_user_params
        user.reload
        expect(user.name).to eq old_name
      end

      it 'returns error message' do
        patch url, headers: auth_header(login_user), params: invalid_user_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(login_user), params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /users/:id' do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it 'removes User' do
      expect do
        delete url, headers: auth_header(login_user)
      end.to change(User, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(login_user)
      expect(response).to have_http_status(:ok)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(login_user)
      expect(json_body).to_not be_present
    end
  end
end
