def stub_paypal_access_token_request(access_token = SecureRandom.uuid)
  response_body = {
    scope: 'https://uri.paypal.com/services/invoicing',
    access_token: access_token,
    token_type: 'Bearer',
    app_id: SecureRandom.uuid,
    expires_in: 30_000,
    nonce: SecureRandom.uuid
  }
  stub_request(:post, Rails.application.secrets[:paypal][:base_url] + '/v1/oauth2/token')
    .to_return(status: 200, body: response_body.to_json, headers: {})
end
