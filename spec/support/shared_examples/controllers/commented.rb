RSpec.shared_examples 'commented' do
  resource_factory = described_class.controller_name.classify.underscore.to_sym #:question or :answer

  let(:user) { create(:user) }
  let(:resource)  { create(resource_factory, author: user) }

  describe 'POST#comment' do
    context 'when authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :comment, params: { id: resource, comment: attributes_for(:comment) }, format: :js }.to change(Comment, :count).by(1)
        end

        it 'renders a comment template' do
          post :comment, params: { id: resource, comment: attributes_for(:comment) }, format: :js

          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save a new comment in the database' do
          expect { post :comment, params: { id: resource, comment: attributes_for(:comment, :invalid) }, format: :js }.to_not change(Comment, :count)
        end

        it 'renders a comment template' do
          post :comment, params: { id: resource, comment: attributes_for(:comment, :invalid) }, format: :js

          expect(response).to render_template 'comments/create'
        end
      end
    end

    context 'when an authenticated user' do
      it 'does not save a comment in the database' do
        expect { post :comment, params: { id: resource, comment: attributes_for(:comment) }, format: :js }.to_not change(Comment, :count)
      end
    end
  end


end