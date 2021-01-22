require 'rails_helper'

RSpec.describe 'Admin::V1::Posts', type: :request do
  let!(:user) { create(:user) }

  context 'GET /posts' do
    let(:url) { '/admin/v1/posts' }
    let!(:posts) { create_list(:post, 10) }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns all Posts' do
      expect(json_body['posts']).to contain_exactly(*posts.as_json)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
