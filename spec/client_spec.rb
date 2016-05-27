require 'spec_helper'

describe BestBuy::Client do
  it 'raises argument error when not provided with an API key' do
    expect{ BestBuy::Client.new }.to raise_exception(ArgumentError, /api key/i)
  end

  it 'creates requests with affiliate tracking ID' do
    bby = BestBuy::Client.new(api_key: '123456', affiliate_tracking_id: 'foobar')
    expect(bby.products(upc: '8675309').to_s).to eq('https://api.bestbuy.com/v1/products(upc=8675309)?LID=foobar&apiKey=123456&format=json')
  end

  let(:bby) { BestBuy::Client.new(api_key: '1234deadbeef') }

  describe 'products' do
    context 'single upc' do
      let(:query) { bby.products(upc: '004815162342') }

      it 'returns a products query for a given upc' do
        expect(query.to_s).to eq('https://api.bestbuy.com/v1/products(upc=004815162342)?apiKey=1234deadbeef&format=json')
      end

      describe 'to_curl' do
        it 'returns an exec\'able curl command' do
          expect(query.to_curl).to eq('curl https://api.bestbuy.com/v1/products(upc=004815162342)?apiKey=1234deadbeef&format=json')
        end
      end
    end

    context 'multiple upcs' do
      let(:query) { bby.products(upc: %w{004815162343 004815162344}) }

      it 'returns a products query for two given upcs' do
        expect(query.to_s).to eq('https://api.bestbuy.com/v1/products(upc=004815162343|upc=004815162344)?apiKey=1234deadbeef&format=json')
      end

      describe 'to_curl' do
        it 'returns an exec\'able curl command' do
          expect(query.to_curl).to eq('curl https://api.bestbuy.com/v1/products(upc=004815162343|upc=004815162344)?apiKey=1234deadbeef&format=json')
        end
      end
    end
  end

  describe 'stores' do
    let(:query) { bby.stores(lat: '42.292659', lng: '-83.7369197', radius: 20) }

    it 'returns a stores query for a given latitude, longitude, and radius' do
      expect(query.to_s).to eq('https://api.bestbuy.com/v1/stores(area(42.292659,-83.7369197,20))?apiKey=1234deadbeef&format=json')
    end

    describe 'to_curl' do
      it 'returns an exec\'able curl command' do
        expect(query.to_curl).to eq('curl https://api.bestbuy.com/v1/stores(area(42.292659,-83.7369197,20))?apiKey=1234deadbeef&format=json')
      end
    end
  end

  describe 'multiple endpoints - in-store availability' do
    let(:query) { bby.stores(lat: '42.292659', lng: '-83.7369197', radius: 20).products(upc: '004815162342') }

    it 'returns an in-store availability query for a given upc within a given latitude, longitude, and radius' do
      expect(query.to_s).to eq('https://api.bestbuy.com/v1/stores(area(42.292659,-83.7369197,20))+products(upc=004815162342)?apiKey=1234deadbeef&format=json')
    end

    describe 'to_curl' do
      it 'returns an exec\'able curl command' do
        expect(query.to_curl).to eq('curl https://api.bestbuy.com/v1/stores(area(42.292659,-83.7369197,20))+products(upc=004815162342)?apiKey=1234deadbeef&format=json')
      end
    end
  end

end
