# frozen_string_literal: true

require 'http'
require 'json'
require 'logger'
require 'rest-client'

module Pinata
  class Error < StandardError; end
  class NotFoundError < Error; end

  class Client
    attr_reader :api_endpoint, :gateway_endpoint, :http_client

    def initialize(pinata_api_key, pinata_secret_api_key, api_endpoint, gateway_endpoint)
      @pinata_api_key = pinata_api_key
      @pinata_secret_api_key = pinata_secret_api_key
      @api_endpoint = api_endpoint
      @gateway_endpoint = gateway_endpoint
      @http_client = HTTP
    end

    def add(path)
      res = RestClient.post "#{@api_endpoint}",
        { file: File.new(path,"rb") },
	{ "pinata_api_key" => @pinata_api_key, "pinata_secret_api_key" => @pinata_secret_api_key }

      if res.code >= 200 && res.code <= 299
        JSON.parse(res.body)
      else
        raise Error, res.body
      end
    end

    def cat(hash, offset, length)
      res = @http_client.get("#{@api_endpoint}/api/v0/cat?arg#{hash}&offset=#{offset}&length=#{length}")
      res.body
    end

    def download(hash, &block)
      url = build_file_url(hash)
      res = RestClient.get(url)

      if block_given?
        res.return!(&block)
      else
        res.return!
      end
    end

    def file_exists?(key)
      url = build_file_url(key)
      res = RestClient.get "#{@gateway_endpoint}#{key}"
      res.code == 200
    end

    def build_file_url(hash)
      "#{@gateway_endpoint}/#{hash}"
    end
  end
end
