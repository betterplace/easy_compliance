require 'spec_helper'

describe EasyCompliance::Client do
  subject(:client) { EasyCompliance::Client }
  before do
    EasyCompliance.api_key = 'key'
    EasyCompliance.api_url = 'url'
  end

  describe '#post' do
    it 'posts to the API URL and returns body and status' do
      expect(Excon).to receive(:post)
        .with('url', body: 'method=2&api_key=key', headers: anything)
        .and_return(double(body: '{}', status: 200))
      expect(client.post(method: :submit)).to eq ['{}', 200]
    end

    it 'raises if the API returned a bad status code' do
      expect(Excon).to receive(:post)
        .with('url', body: 'method=2&api_key=key', headers: anything)
        .and_return(double(body: '{}', status: 500))
      expect { client.post(method: :submit) }.to raise_error(client::Error, /500/)
    end

    it 'raises if the connection failed' do
      expect(Excon).to receive(:post)
        .with('url', body: 'method=2&api_key=key', headers: anything)
        .and_raise(Excon::Errors::SocketError.new)
      expect { client.post(method: :submit) }.to raise_error(client::Error, /Socket/)
    end

    it 'raises if called with an unsupported method' do
      expect { client.post(method: :foo) }.to raise_error(client::Error, /method/)
    end

    it 'raises if api_key is not set' do
      EasyCompliance.api_key = nil
      expect { client.post(method: :submit) }.to raise_error(client::Error, /api_key/)
    end

    it 'raises if api_url is not set' do
      EasyCompliance.api_url = nil
      expect { client.post(method: :submit) }.to raise_error(client::Error, /api_url/)
    end
  end
end
