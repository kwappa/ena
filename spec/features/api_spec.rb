require 'rails_helper'

RSpec.feature 'api#me.json', type: :feature do
  let(:app) { create(:oauth_application) }
  let(:user) { create(:user) }

  scenario 'return user profile as json' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    token = client.password.get_token(user.email, user.password)

    response = token.get('/api/me.json')
    user_profile = JSON.parse(response.body)

    columns = %w[id name nick email member_number screen_name screen_name_kana authority_id suspend_reason suspended_on]
    expected_hash = columns.each_with_object({}) { |column, result| result[column] = user.send(column.to_sym) }

    expect(user_profile).to include(expected_hash)
  end
end
