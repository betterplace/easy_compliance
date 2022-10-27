require 'spec_helper'

describe EasyCompliance::Client do
  subject(:client) { EasyCompliance::Client }
  before do
    EasyCompliance.api_key = 'key'
    EasyCompliance.api_url = 'url'
    EasyCompliance.retry_limit = nil
    EasyCompliance.retry_interval = nil
  end

  describe '#post' do
    it 'posts to the API URL and returns an EasyCompliance::Result' do
      expect(Excon).to receive(:post)
        .with(
          'url',
          body: 'method=2&api_key=key',
          headers: anything,
          idempotent: true,
          retry_limit: 3,
          retry_interval: 5
        )
        .and_return(double(body: '{}', status: 200))
      result = client.post(method: 2)
      expect(result).to be_an EasyCompliance::Result
      expect(result.status).to eq 200
    end

    it 'raises if the API returned a bad status code' do
      expect(Excon).to receive(:post)
        .with(
          'url',
          body: 'method=2&api_key=key',
          headers: anything,
          idempotent: true,
          retry_limit: 3,
          retry_interval: 5
        )
        .and_return(double(body: '{}', status: 500))
      expect { client.post(method: 2) }.to raise_error(client::Error, /500/)
    end

    it 'raises if the connection failed' do
      expect(Excon).to receive(:post)
        .with(
          'url',
          body: 'method=2&api_key=key',
          headers: anything,
          idempotent: true,
          retry_limit: 3,
          retry_interval: 5
        )
        .and_raise(Excon::Errors::SocketError.new)
      expect { client.post(method: 2) }.to raise_error(client::Error, /Socket/)
    end

    it 'raises if there is any OpenSSL::OpenSSLError' do
      expect(Excon).to receive(:post)
        .with(
          'url',
          body: 'method=2&api_key=key',
          headers: anything,
          idempotent: true,
          retry_limit: 3,
          retry_interval: 5
        )
        .and_raise(OpenSSL::SSL::SSLErrorWaitReadable.new)
      expect { client.post(method: 2) }.to raise_error(client::Error, /SSLError/)
    end

    it 'raises if api_key is not set' do
      EasyCompliance.api_key = nil
      expect { client.post(method: 2) }.to raise_error(client::Error, /api_key/)
    end

    it 'raises if api_url is not set' do
      EasyCompliance.api_url = nil
      expect { client.post(method: 2) }.to raise_error(client::Error, /api_url/)
    end

    it 'uses a default value of 3 for retry_limit unless it is set' do
      expect(Excon).to receive(:post).with(
        'url',
        body: 'method=2&api_key=key',
        headers: anything,
        idempotent: true,
        retry_limit: 3,
        retry_interval: 5
      ).and_return(double(body: '{}', status: 200))
      client.post(method: 2)

      EasyCompliance.retry_limit = 0
      expect(Excon).to receive(:post).with(
        'url',
        body: 'method=2&api_key=key',
        headers: anything,
        idempotent: true,
        retry_limit: 0,
        retry_interval: 5
      ).and_return(double(body: '{}', status: 200))
      client.post(method: 2)
    end

    it 'uses a default value of 5 for retry_interval unless it is set' do
      EasyCompliance.retry_interval = nil
      expect(Excon).to receive(:post).with(
        'url',
        body: 'method=2&api_key=key',
        headers: anything,
        idempotent: true,
        retry_limit: 3,
        retry_interval: 5
      ).and_return(double(body: '{}', status: 200))
      client.post(method: 2)

      EasyCompliance.retry_interval = 0
      expect(Excon).to receive(:post).with(
        'url',
        body: 'method=2&api_key=key',
        headers: anything,
        idempotent: true,
        retry_limit: 3,
        retry_interval: 0
      ).and_return(double(body: '{}', status: 200))
      client.post(method: 2)
    end
  end
end
