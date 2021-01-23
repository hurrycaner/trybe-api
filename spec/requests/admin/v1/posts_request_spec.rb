require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Admin::V1::Posts', type: :request do
  let!(:user) { create(:user) }

  context 'GET /posts' do
    let(:url) { '/admin/v1/posts' }
    let!(:posts) { create_list(:post, 2) }
    before(:each) { get url, headers: auth_header(user) }

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
    before(:each) { get url, headers: auth_header(user) }

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

    context 'with valid params' do
      let(:post_params) { { post: attributes_for(:post) }.to_json }

      it 'adds a new Post' do
        expect do
          post url, headers: auth_header(user), params: post_params
        end.to change(Post, :count).by(1)
      end

      it 'returns last added Post' do
        post url, headers: auth_header(user), params: post_params
        expected_post = merge_user_info_in_post(Post.last)
        expect(json_body['post']).to eq expected_post
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: post_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_post_params) do
        { post: attributes_for(:post, title: nil) }.to_json
      end

      it 'does not add a new Post' do
        expect do
          post url, headers: auth_header(user), params: invalid_post_params
        end.to_not change(Post, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: invalid_post_params
        expect(json_body['errors']['fields']).to have_key('title')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: invalid_post_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /posts/:id' do
    let(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }

    context 'with valid params' do
      let(:new_title) { 'My new Title' }
      let(:post_params) { { post: { title: new_title } }.to_json }
      before(:each) { patch url, headers: auth_header(user), params: post_params }

      it 'updates Post' do
        post.reload
        expect(post.title).to eq new_title
      end

      it 'returns updated Post' do
        expected_post = []
        expected_post << post.reload
        expected_post = expected_post.map { |post| merge_user_info_in_post(post) }
        expect(json_body['post']).to eq(*expected_post)
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_post_params) do
        { post: attributes_for(:post, title: nil) }.to_json
      end

      it 'does not update Post' do
        old_title = post.title
        patch url, headers: auth_header(user), params: invalid_post_params
        post.reload
        expect(post.title).to eq old_title
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: invalid_post_params
        expect(json_body['errors']['fields']).to have_key('title')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: invalid_post_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /posts/:id' do
    let!(:post) { create(:post) }
    let(:url) { "/admin/v1/posts/#{post.id}" }

    it 'removes Post' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Post, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(json_body).to_not be_present
    end
  end
end
# rubocop:enable Metrics/BlockLength

def merge_user_info_in_post(post)
  user = User.find(post.user_id)
  json = post.as_json
  json['user'] = user.as_json
  json.delete('user_id')
  json
end
