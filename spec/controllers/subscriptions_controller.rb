require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    let(:create_request) { post :create, params: { question_id: question, format: :js } }

    context 'when user is authenticated' do
      before { login(user) }

      it 'saves a new subscription for the question in the database' do
        expect { create_request }.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'when user is not authenticated' do
      it 'does not save a new subscription in the database' do
        expect { create_request }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }
    let(:destroy_request) { delete :destroy, params: { id: subscription, format: :js } }

    context 'when user is authenticated' do
      it 'deletes subscription from database' do
        login(user)
        expect { destroy_request }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'when user other authenticated ' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, author: other_user) }

      it 'does not delete subscription from database' do
        login(other_user)
        expect { destroy_request }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete the subscription' do
        expect { destroy_request }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
