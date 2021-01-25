require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe Admin::ModelLoadingService do
  context 'when #call' do
    let!(:posts) { create_list(:post, 15) }

    context 'when params are present' do
      let!(:search_posts) do
        posts = []
        15.times do |n|
          posts << create(:post, title: "Search #{n + 1}", content: 'Content')
        end
        posts
      end

      let!(:unexpected_posts) do
        posts = []
        15.times do |n|
          posts << create(:post, title: "Search #{n + 16}")
        end
        posts
      end

      let(:params) do
        { search: { title: 'Search', content: 'Content' },
          order: { title: :desc }, page: 2, length: 4 }
      end

      it 'performs right :length following pagination' do
        service = described_class.new(Post.all, params)
        service.call
        expect(service.pagination[:length]).to eq 4
      end

      it 'do right search, order and pagination' do
        search_posts.sort! { |a, b| b[:title] <=> a[:title] }
        service = described_class.new(Post.all, params)
        service.call
        expected_posts = search_posts[4..7]
        expect(service.records).to contain_exactly(*expected_posts)
      end

      it 'sets right :page' do
        service = described_class.new(Post.all, params)
        service.call
        expect(service.pagination[:page]).to eq 2
      end

      it 'sets right :length' do
        service = described_class.new(Post.all, params)
        service.call
        expect(service.pagination[:length]).to eq 4
      end

      it 'sets right :total' do
        service = described_class.new(Post.all, params)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it 'sets right :total_pages' do
        service = described_class.new(Post.all, params)
        service.call
        expect(service.pagination[:total_pages]).to eq 4
      end

      it 'does not return unexpected records' do
        params.merge!(page: 1, length: 50)
        service = described_class.new(Post.all, params)
        service.call
        expect(service.records).to_not include(*unexpected_posts)
      end
    end

    context 'when params are not present' do
      it 'returns default :length pagination' do
        service = described_class.new(Post.all, nil)
        service.call
        expect(service.records.count).to eq 10
      end

      it 'returns first 10 records' do
        service = described_class.new(Post.all, nil)
        service.call
        expected_posts = posts[0..9]
        expect(service.records).to contain_exactly(*expected_posts)
      end

      it 'sets right :page' do
        service = described_class.new(Post.all, nil)
        service.call
        expect(service.pagination[:page]).to eq 1
      end

      it 'sets right :length' do
        service = described_class.new(Post.all, nil)
        service.call
        expect(service.pagination[:length]).to eq 10
      end

      it 'sets right :total' do
        service = described_class.new(Post.all, nil)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it 'sets right :total_pages' do
        service = described_class.new(Post.all, nil)
        service.call
        expect(service.pagination[:total_pages]).to eq 2
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
