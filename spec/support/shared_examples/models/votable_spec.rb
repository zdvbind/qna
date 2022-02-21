RSpec.shared_examples 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:votable) { create described_class.to_s.underscore.to_sym }

    context 'when votable does not have any votes' do
      it 'is returning zero' do
        expect(votable.rating).to be_zero
      end
    end

    context 'when votable has some votes' do
      let!(:like_votes) { create_list :vote, 3, :like, votable: votable }
      let!(:dislike_votes) { create_list :vote, 1, :dislike, votable: votable }

      it 'is returning sum of likes and dislikes' do
        expect(votable.rating).to eq 2
      end
    end
  end

  describe '#cancel' do
    let(:user) { create :user }
    let(:user1) { create :user }
    let(:votable) { create described_class.to_s.underscore.to_sym }
    let(:like_vote) { create :vote, :like, votable: votable, user: user1 }
    let(:like_vote) { create :vote, :like, votable: votable, user: user }

    it "is destroying user's all votes for current votable" do
      votable.cancel(user)
      expect(votable.votes.find_by(user: user)).to be_nil
    end
  end
end
