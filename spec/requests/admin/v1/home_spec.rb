require 'rails_helper'

describe '/home', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/admin/v1/home' }

  it 'returns errors for requests without credentials' do
    get url
    expect(json_body).to eq({ 'errors' => ['Para continuar, efetue login ou registre-se.'] })
  end

  it 'returns status 401: Unauthorized for requests without credentials' do
    get url
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns { "ok" => true } for successful get requests' do
    get url, headers: auth_header(user)
    expect(json_body).to eq({ 'ok' => true })
  end

  it 'returns { ok: true } for successful get requests - with symbolized keys' do
    get url, headers: auth_header(user)
    expect(json_body(symbolize_keys: true)).to eq({ ok: true })
  end

  it 'returns status 200: ok for successful get requests' do
    get url, headers: auth_header(user)
    expect(response).to have_http_status(:ok)
  end
end
