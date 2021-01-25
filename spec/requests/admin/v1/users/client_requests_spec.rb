require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :client', type: :request do
  let!(:login_user) { create(:user, profile: :client) }

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

    before(:each) { post url, headers: auth_header(login_user) }

    include_examples 'forbidden access'
  end

  context 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    before(:each) { patch url, headers: auth_header(login_user) }

    include_examples 'forbidden access'
  end

  context 'DELETE /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    before(:each) { delete url, headers: auth_header(login_user) }

    include_examples 'forbidden access'
  end
end

def merge_user_info_in_post(post)
  user = User.find(post.user_id)
  json = post.as_json
  json['user'] = user.as_json(only: %i[id name email profile image])
  json.delete('user_id')
  json
end
