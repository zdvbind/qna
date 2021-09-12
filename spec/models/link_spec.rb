require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { is_expected.to validate_url_of(:url) }
  end

  describe 'associations' do
    it { should belong_to :linkable }
  end
end
