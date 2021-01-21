require 'rails_helper'

RSpec.describe 'Admin::V1::Users', type: :request do
  let(:user) { create(:user) }

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
    let(:url) { "/admin/v1/users#{user.id}" }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns the requested User' do
      expected_user = user.as_json(only: %i[id name image email profile])
      expect(json_body['user']).to eq expected_user
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
