RSpec.describe 'University Registration', type: :request do
  let(:header) { { HTTP_ACCEPT: 'application/json' } }

  describe 'with valid credentials for University role' do
    before 'post new University info' do
      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                     name: 'Fat Bob',
                                     role: 'university',
                                     password: 'password',
                                     password_confirmation: 'password' },
                                     headers: headers
    end

    it 'returns a 200 response' do
      expect(response.status).to eq 200
    end

    it 'returns 5 registration keys' do
      expect(response_json['registration_keys'].count).to eq 5
    end

    it 'JSON body response contains a role' do
      expect(response_json['data']['role']).to eq 'university'
    end
  end

  describe 'with valid credentials for Research Group role' do
    before 'post new Research Group info' do
      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                    name: 'Fat Bob',
                                    role: 'research_group',
                                    password: 'password',
                                    password_confirmation: 'password' },
                                    headers: headers
    end

    it 'returns zero registration keys' do
      expect(response_json['registration_keys']).to eq nil
    end

  end

  describe 'returns an error message when user submits' do
    before 'posting erroneous data to URL' do
      post '/api/v0/auth', params: { email: 'example@craftacademy',
                                     password: 'password',
                                     password_confirmation: 'wrong_password' },
                                     headers: headers
    end

    it 'non-matching password confirmation' do
      expect(response_json['errors']['password_confirmation']).to eq ["doesn't match Password"]
    end

    it 'an invalid email address' do
      expect(response_json['errors']['email']).to eq ['is not an email']
    end
  end

    it 'an already registered email' do
      create(:user, email: 'example@craftacademy.se',
                                password: 'password',
                                password_confirmation: 'password')

    post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                   password: 'password',
                                   password_confirmation: 'password' }, headers:
                                   headers

    expect(response_json['errors']['email']).to eq ['has already been taken']
  end
end
