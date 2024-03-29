require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  describe 'validates' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:user) }
  end
end
