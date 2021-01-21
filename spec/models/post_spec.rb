require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
end
