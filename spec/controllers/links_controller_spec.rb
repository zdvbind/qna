require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'when authenticated user is author' do
      before { login(author) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when authenticated user is not an author' do
      before { login(user) }

      it "tries to delete other's user link" do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when user is not authenticated' do
      it 'tries to delete link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      end

      it 'redirects to new session view' do
        delete :destroy, params: { id: link }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
