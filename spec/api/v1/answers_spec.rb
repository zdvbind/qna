require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
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

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, :with_attachments, question: question, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let(:links) { create_list(:link, 3, linkable: answer) }
      let(:comments) { create_list(:comment, 3, commentable: answer) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Successful response'

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id body created_at updated_at user_id] }
        let(:resource_from_response) { answer_response }
        let(:resource) { answer }
      end

      it 'contains best' do
        expect(answer_response['best']).to eq answer.best?
      end

      context 'Attachments' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { answer_response['files'] }
          let(:count_of_resources) { answer.files.size }
        end
      end

      context 'Links' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { answer_response['links'] }
          let(:count_of_resources) { answer.links.size }
        end
      end

      context 'Comments' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { answer_response['comments'] }
          let(:count_of_resources) { answer.comments.size }
        end
      end
    end
  end
end
