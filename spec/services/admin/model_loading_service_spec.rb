require 'rails_helper'

describe Admin::ModelLoadingService do
  context 'when #call' do
    let!(:posts) { create_list(:post, 15) }

    context 'with params are present' do
      let!(:search_posts) do
        posts = []
        15.times { |n| posts << create(:post, title: "Search #{n + 1}") }
        posts
      end

      let(:params) do
        { search: { title: 'Search' }, order: { title: :desc }, page: 2, length: 4 }
      end

      it 'returns right :length following pagination' do
        service = described_class.new(Post.all, params)
        result_posts = service.call
        expect(result_posts.count).to eq 4
      end

      it 'returns records following search, order and pagination' do
        search_posts.sort! { |a, b| b[:title] <=> a[:title] }
        service = described_class.new(Post.all, params)
        result_posts = service.call
        expected_posts = search_posts[4..7]
        expect(result_posts).to contain_exactly(*expected_posts)
      end
    end

    context 'without params are not present' do
      it 'returns default :length pagination' do
        service = described_class.new(Post.all, nil)
        result_posts = service.call
        expect(result_posts.count).to eq 10
      end

      it 'returns first 10 records' do
        service = described_class.new(Post.all, nil)
        result_posts = service.call
        expected_posts = posts[0..9]
        expect(result_posts).to contain_exactly(*expected_posts)
      end
    end
  end
end
