require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/question/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, author: user) }

      before do
        do_request(method, api_path, params: { question_id: question.id, access_token: access_token.token },
                                     headers: headers)
      end

      it_behaves_like 'Successful response'

      it_behaves_like 'List of resources returnable' do
        let(:resources_from_response) { json['answers'] }
        let(:count_of_resources) { answers.size }
      end

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:resource_from_response) { json['answers'].first }
        let(:resource) { answers.first }
      end

      it 'contains best' do
        expect(json['answers'].first['best']).to eq answers.first.best?
      end
    end
  end
end
