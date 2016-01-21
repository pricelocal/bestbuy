require 'spec_helper'

describe BestBuy::Request do
  it 'only supports VALID_ENDPOINTS' do
    expect{described_class.new(api_key: '1234', endpoint: 'nuclear_waste')}.to raise_exception(BestBuy::APIError, /unsupported/)
  end

  it 'joins multiple filters with pipes' do
    req = described_class.new(api_key: '1234', endpoint: 'products', filters: ["upc=004815162342", "longDescription=GoPro*"])
    expect(req.to_s).to eq("https://api.bestbuy.com/v1/products(upc=004815162342|longDescription=GoPro*)?apiKey=1234&format=json")
  end

  describe 'add_endpoint' do
    it "joins multiple endpoints with plusses" do
      req = described_class.new(api_key: '1234', endpoint: 'products', filters: ["upc=004815162342", "longDescription=GoPro*"])
      req.add_endpoint('stores', 'area(42.292659,-83.7369197,20)')
      expect(req.to_s).to eq("https://api.bestbuy.com/v1/products(upc=004815162342|longDescription=GoPro*)+stores(area(42.292659,-83.7369197,20))?apiKey=1234&format=json")
    end
  end

  describe 'select' do
    it 'restricts the returned fields from the API' do
      req = described_class.new(api_key: '1234', endpoint: 'products', filters: ["upc=004815162342", "longDescription=GoPro*"])
      expect(req.pluck(:sku, :name).to_s).to eq("https://api.bestbuy.com/v1/products(upc=004815162342|longDescription=GoPro*)?apiKey=1234&format=json&show=sku,name")
    end
  end
end
