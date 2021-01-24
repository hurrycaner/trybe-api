require 'rails_helper'

RSpec.describe 'Admin::V1::Posts without authentication', type: :request do
  context 'GET /posts' do
    let(:url) { '/admin/v1/posts' }
    let!(:posts) { create_list(:post, 2) }
    before(:each) { get url, headers: { 'Content-type' => 'application/json', 'Accept' => 'application/json' } }

    it 'returns all Posts' do
      expected_posts = posts.map { |post| merge_user_info_in_post(post) }
      expect(json_body['posts']).to contain_exactly(*expected_posts.as_json)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'GET /posts/:id' do
    let(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }
    before(:each) { get url, headers: { 'Content-type' => 'application/json', 'Accept' => 'application/json' } }

    it 'returns the requested Post' do
      expected_post = merge_user_info_in_post(post)
      expect(json_body['post']).to eq expected_post
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /posts' do
    let(:url) { '/admin/v1/posts' }

    before(:each) { post url }

    include_examples 'unauthenticated access'
  end

  context 'PATCH /posts/:id' do
    let(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }

    before(:each) { patch url }

    include_examples 'unauthenticated access'
  end

  context 'DELETE /posts/:id' do
    let(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }

    before(:each) { delete url }

    include_examples 'unauthenticated access'
  end
end

def merge_user_info_in_post(post)
  user = User.find(post.user_id)
  json = post.as_json
  json['user'] = user.as_json(only: %i[id name email profile image])
  json.delete('user_id')
  json
end
