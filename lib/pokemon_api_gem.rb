require 'net/http'
require 'json'

class PokemonAPIClient
    BASE_URL = "https://www.pokemonpricetracker.com/api"
    @api = ""

    def self.initialize(api_key)
        @api = api_key
    end

    def self.fetch_card_by_name(name)
        encoded_name = URI.encode_www_form_component(name)
        uri = URI("#{BASE_URL}/cards?search=#{encoded_name}")
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{@api}"

        response=Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
        end

        JSON.parse(response.body)
    end
end

