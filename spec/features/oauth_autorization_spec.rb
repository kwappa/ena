require 'rails_helper'

RSpec.feature 'OAuth authorization', type: :feature do
  let(:app) { create(:oauth_application) }
  let(:user) { create(:user) }

  scenario 'auth ok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    token = client.password.get_token(user.email, user.password)
    expect(token).to_not be_expired
  end

  scenario 'auth nok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    expect { client.password.get_token(user.email, "123")}.to raise_error(OAuth2::Error)
  end
end
