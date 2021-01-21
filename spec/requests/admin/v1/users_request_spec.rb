require 'rails_helper'

RSpec.describe 'Admin::V1::Users', type: :request do
  let(:user) { create(:user) }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 10) }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns all Users' do
      expect(json_body['users']).to contain_exactly(*users.as_json)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
