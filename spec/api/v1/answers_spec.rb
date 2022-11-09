require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

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
        expect(json['answers'].first['best']).to eq answers.first&.best?
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

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let(:params) do
        { question: question, access_token: access_token.token, author: author, answer: attributes_for(:answer) }
      end

      before { do_request(method, api_path, params: params, headers: headers) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'Successful response'
      end

      context 'with invalid attributes' do
        let(:params) do
          { question: question, access_token: access_token.token,
            author: author, answer: attributes_for(:answer, :invalid) }
        end

        it 'does not save a new answer in the database' do
          do_request(method, api_path, params: params, headers: headers)

          expect(Answer.count).to be_zero
        end

        it 'returns unprocessable_entity status' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        let(:params) do
          { id: answer, question: question, answer: { body: 'NewBody' }, access_token: access_token.token }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it_behaves_like 'Successful response'

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'NewBody'
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          { id: answer, question: question, answer: attributes_for(:answer, :invalid),
            access_token: access_token.token }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it 'does not change question attributes' do
          answer.reload

          expect(answer.body).to eq 'MyBody'
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end
      end

      context 'not author can not update question' do
        let(:user) { create(:user) }
        let(:not_author_access_token) { create(:access_token, resource_owner_id: user.id) }

        before do
          do_request(method, api_path, params: { id: answer,
                                                 question: question,
                                                 answer: { body: 'NewBody' },
                                                 access_token: not_author_access_token.token },
                                       headers: headers)
        end

        it 'does not change answer attributes' do
          answer.reload

          expect(answer.body).to eq 'MyBody'
        end

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      before do
        do_request(method, api_path, params: { id: answer, access_token: access_token.token }, headers: headers)
      end

      it_behaves_like 'Successful response'

      it 'deletes the answer' do
        expect(Answer.count).to be_zero
      end

      it 'returns successful message' do
        expect(json['messages']).to include('Your answer was destroyed')
      end
    end

    context 'not authorized' do
      let(:not_author) { create(:user) }
      let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }
      let(:params) { { id: answer, question: question, access_token: not_author_access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it 'tries to delete answer' do
        expect(Answer.count).to eq 1
      end

      it 'returns status 403' do
        expect(response.status).to eq 403
      end
    end
  end
end
