require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user_author) { create(:user) }
  let(:user_not_author) { create(:user) }
  let(:question) { create(:question, :with_attachments, author: user_author) }

  describe 'DELETE #destroy' do

    context 'Unauthenticated user' do
      it 'can not delete the file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }
          .to_not change(question.files, :count)
      end
    end

    context 'Authenticated author' do
      before { login(user_author) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }
          .to change(question.files, :count).by(-1)
      end
    end

    context 'Not author' do
      before { login(user_not_author) }

      it 'can not delete the file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.
          to_not change(question.files, :count)
      end
    end
    #

  end
end
