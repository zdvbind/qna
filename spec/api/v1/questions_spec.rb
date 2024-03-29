require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
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

      it_behaves_like 'List of resources returnable' do
        let(:resources_from_response) { json['questions'] }
        let(:count_of_resources) { Question.count }
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

        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { question_response['answers'] }
          let(:count_of_resources) { answers.count }
        end

        it_behaves_like 'Public fields returnable' do
          let(:attributes) { %w[id body user_id created_at updated_at] }
          let(:resource_from_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_attachments) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let(:links) { create_list(:link, 3, linkable: question) }
      let(:comments) { create_list(:comment, 3, commentable: question) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Successful response'

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id title body best_answer_id created_at updated_at] }
        let(:resource_from_response) { question_response }
        let(:resource) { question }
      end

      context 'Attachments' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { question_response['files'] }
          let(:count_of_resources) { question.files.size }
        end
      end

      context 'Links' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { question_response['links'] }
          let(:count_of_resources) { question.links.size }
        end
      end

      context 'Comments' do
        it_behaves_like 'List of resources returnable' do
          let(:resources_from_response) { question_response['comments'] }
          let(:count_of_resources) { question.comments.size }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect do
            do_request(method, api_path, params: { question: attributes_for(:question),
                                                   access_token: access_token.token },
                                         headers: headers)
          end.to change(Question, :count).by(1)
        end

        it 'returns successful status' do
          do_request(method, api_path, params: { question: attributes_for(:question),
                                                 access_token: access_token.token },
                                       headers: headers)
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it 'does not saves question' do
          expect do
            do_request(method, api_path, params: { question: attributes_for(:question, :invalid),
                                                   access_token: access_token.token },
                                         headers: headers)
          end.to_not change(Question, :count)
        end

        it 'returns unprocessable_entity status' do
          do_request(method, api_path, params: { question: attributes_for(:question, :invalid),
                                                 access_token: access_token.token },
                                       headers: headers)
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        before do
          do_request(method, api_path, params: { id: question,
                                                 question: { title: 'new title', body: 'new body' },
                                                 access_token: access_token.token },
                                       headers: headers)
        end

        it_behaves_like 'Successful response'

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end
      end

      context 'with invalid attributes' do
        before do
          do_request(method, api_path, params: { question: attributes_for(:question, :invalid),
                                                 access_token: access_token.token },
                                       headers: headers)
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end
      end

      context 'not author tries to update question' do
        let(:not_author_access_token) { create(:access_token) }

        before do
          do_request(method, api_path, params: { id: question,
                                                 question: { title: 'new title', body: 'new body' },
                                                 access_token: not_author_access_token.token },
                                       headers: headers)
        end

        it 'does not change question attributes' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let(:params) { { id: question, access_token: access_token.token } }
      before do
        do_request(method, api_path, params: params, headers: headers)
      end

      it_behaves_like 'Successful response'

      it 'deletes the question' do
        expect(Question.count).to be_zero
      end

      it 'returns successful message' do
        expect(json['messages']).to include('Your question was destroyed')
      end
    end

    context 'not authorized' do
      let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }
      let(:params) { { id: question, access_token: not_author_access_token.token } }

      before do
        do_request(method, api_path, params: params, headers: headers)
      end

      it 'does not delete the question' do
        expect(Question.count).to eq 1
      end

      it 'returns status 403' do
        expect(response.status).to eq 403
      end
    end
  end
end
