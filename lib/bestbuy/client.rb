module BestBuy
  # A BestBuy::Client allows queries to be constructed to the BestBuy API
  class Client
    # @param api_key[String] The API Key for making requests to the BestBuy API. Get one at https://remix.mashery.com/member/register
    def initialize(options = {})
      api_key = options[:api_key]
      raise ArgumentError, "API Key not set" unless api_key

      affiliate_tracking_id = options[:affiliate_tracking_id]

      @api_key = api_key
      @affiliate_tracking_id = affiliate_tracking_id
    end

    # Issues a request for products held in the BestBuy API
    #
    # @param params[Hash] Parameters passed to the products API call which filter the result set. Parameters are combined by logical OR
    # @return Array<Hash> Products that were found in the BestBuy API
    def products(params = {})
      filters = params.map {|key, value| "#{key}=#{value}"}
      BestBuy::Request.new(api_key: @api_key,
                           affiliate_tracking_id: @affiliate_tracking_id,
                           endpoint: 'products',
                           filters: filters)
    end

    # Issues a request for stores held in the BestBuy API
    #
    # @param params[Hash] Parameters passed to the store API call which filter the result set. Parameters are combined by logical OR
    # @return Array<Hash> Stores that were found in the BestBuy API
    def stores(query = '', params = {})
      filters = [query] + params.map {|key, value| "#{key}=#{value}"}
      BestBuy::Request.new(api_key: @api_key,
                           affiliate_tracking_id: @affiliate_tracking_id,
                           endpoint: 'stores',
                           filters: filters)
    end

  end
end
