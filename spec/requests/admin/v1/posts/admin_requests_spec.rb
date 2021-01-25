require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Admin::V1::Posts as :admin', type: :request do
  let!(:user) { create(:user) }

  context 'GET /posts' do
    let(:url) { '/admin/v1/posts' }
    let!(:posts) { create_list(:post, 10) }

    context 'without any params' do
      it 'returns 10 posts' do
        get url, headers: auth_header(user)
        expect(json_body['posts'].count).to eq 10
      end

      it 'returns 10 first posts' do
        get url, headers: auth_header(user)
        expected_posts = posts[0..9].map { |post| merge_user_info_in_post(post) }
        expect(json_body['posts']).to contain_exactly(*expected_posts)
      end

      it 'returns success status' do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context 'with search[title] param' do
      let!(:search_title_posts) do
        posts = []
        15.times { |n| posts << create(:post, title: "Search #{n + 1}") }
        posts
      end

      let(:search_params) { { search: { title: 'Search' } } }

      it 'returns only seached posts limited by default pagination' do
        get url, headers: auth_header(user), params: search_params
        expected_posts = search_title_posts[0..9].map do |post|
          merge_user_info_in_post(post)
        end
        expect(json_body['posts']).to contain_exactly(*expected_posts)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: search_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 15, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: search_params }
      end
    end

    context 'with pagination params' do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it 'returns records sized by :length' do
        get url, headers: auth_header(user), params: pagination_params
        expect(json_body['posts'].count).to eq length
      end

      it 'returns posts limited by pagination' do
        get url, headers: auth_header(user), params: pagination_params
        expected_posts = posts[5..9].map { |post| merge_user_info_in_post(post) }
        expect(json_body['posts']).to contain_exactly(*expected_posts)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 10, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end

    context 'with order params' do
      let(:order_params) { { order: { title: 'desc' } } }

      it 'returns ordered posts limited by default pagination' do
        get url, headers: auth_header(user), params: order_params
        posts.sort! { |a, b| b[:title] <=> a[:title] }
        expected_posts = posts[0..9].map { |post| merge_user_info_in_post(post) }
        expect(json_body['posts']).to contain_exactly(*expected_posts)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user), params: order_params }
      end
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
        expected_post = merge_user_info_in_post(post.reload)
        expect(json_body['post']).to eq expected_post
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
  json['user'] = user.as_json(only: %i[id name email profile image])
  json.delete('user_id')
  json
end
