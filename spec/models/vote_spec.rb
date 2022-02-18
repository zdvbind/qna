require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user }
    it { should validate_uniqueness_of(:user).scoped_to(:votable_type, :votable_id) }
  end
end
