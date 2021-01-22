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

  context 'GET /posts/:id' do
    let(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }
    before(:each) { get url, headers: auth_header(user) }

    it 'returns the requested Post' do
      expected_post = merge_user_info_in_post(post)
      expect(json_body['post']).to eq expected_post
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end
end

def merge_user_info_in_post(post)
  user = User.find(post.user_id)
  json = post.as_json
  json['user'] = user.as_json
  json.delete('user_id')
  json
end
