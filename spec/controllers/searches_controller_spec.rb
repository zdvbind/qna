require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  let(:question) { create(:question) }
  let(:params) { { type: 'Questions', request: question.body } }

  describe 'GET #show' do
    it 'renders show view', sphinx: true do
      ThinkingSphinx::Test.run do
        get :show, params: params
        expect(response).to render_template :show
      end
    end
  end
end
