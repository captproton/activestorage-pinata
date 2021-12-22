require 'pinata/client'

module ActiveStorage
  class Service::PinataService < Service
    attr_accessor :client

    def initialize(pinata_api_key:, pinata_secret_api_key:, api_endpoint:, gateway_endpoint:)
      @client = Pinata::Client.new pinata_api_key, pinata_secret_api_key, api_endpoint, gateway_endpoint
    end

    # File is uploaded to Pinata and a hash
    # is returned which is used to retrieve the file
    # Change the key of the blob to that of the hash
    def upload(key, io, checksum: nil, **)
      instrument :upload, key: key, checksum: checksum do
        data = @client.add io.path
        cid_key = data['IpfsHash']

        if blob_exists?(cid_key)
          existing_blob = find_blob(cid_key)
          new_blob = find_blob(key)
          attachment = Attachment.last
          
          attachment.update blob_id: existing_blob.id
          new_blob.destroy!
        else
          find_blob(key).update key: cid_key
        end
      end
    end

    def download(key, &block)
      if block_given?
        instrument :streaming_download, key: key do
          @client.download key, &block
        end
      else
        instrument :download, key: key do
          @client.download key
        end
      end
    end

    def download_chunk(key, range)
      instrument :download_chunk, key: key, range: range do
        @client.cat key, range.begin, range.size
      end
    end

    def url(key, content_type: nil, filename: nil, expires_in: nil, disposition: nil)
      instrument :url, key: key do
        @client.build_file_url key
      end
    end

    def exists?(key)
      instrument :exist, key: key do
        @client.file_exists?(key)
      end
    end

    def url_for_direct_upload(key, expires_in: nil, content_type: nil, content_length: nil, checksum: nil)
      instrument :url_for_direct_upload, key: key do
        "#{@client.api_endpoint}/api/v0/add"
      end
    end

    private

    def find_blob(key)
      Blob.find_by_key key
    end

    def blob_exists?(key)
      Blob.exists?(key: key)
    end
  end
end
