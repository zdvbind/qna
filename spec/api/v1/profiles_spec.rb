require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Successful response'

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:resource_from_response) { json['user'] }
        let(:resource) { me }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/all_except_me' do
    let(:api_path) { '/api/v1/profiles/all_except_me' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 4) }
      let(:me) { users.last }
      let(:not_me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Successful response'

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end

      it 'returns list without current user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it_behaves_like 'Public fields returnable' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:resource_from_response) { json['users'].first }
        let(:resource) { not_me }
      end
    end
  end
end
