require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Successful response'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id title body best_answer_id created_at updated_at] }
        let(:resource_from_response) { question_response }
        let(:resource) { question }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
