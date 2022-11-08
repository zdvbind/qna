shared_examples_for 'API authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '12345' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Successful response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Public fields returnable' do
  it 'returns all public fields' do
    attributes.each do |attr|
      expect(resource_from_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'List of resources returnable' do
  it 'returns list of resources' do
    expect(resources_from_response.size).to eq count_of_resources
  end
end

shared_examples_for 'Unable to return private fields' do
  it 'does not return private fields' do
    attributes.each do |attr|
      expect(resource_from_response).to_not have_key(attr)
    end
  end
end
