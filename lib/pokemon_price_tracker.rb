require 'net/http'
require 'json'
require 'timeout'

class PokemonAPIClient
    BASE_URL = "https://www.pokemonpricetracker.com/api/v2/cards"

    def self.configure(api_key)
        @api = api_key
    end

    def self.fetch_card_by_name(name)
        puts "Fetching card #{name}"
        puts "..."

        begin
            Timeout.timeout(100) do
                uri = URI("#{BASE_URL}")
                params = {
                    search: name,
                    set: 'temporal',
                    limit: 5,
                    includeHistory: 'false'
                }
                uri.query = URI.encode_www_form(params)

                request = Net::HTTP::Get.new(uri)
                request["Authorization"] = "Bearer #{@api}"

                response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {
                    |http| http.request(request)
                }
                if response.code.to_i == 200
                    puts "Status #{response.code}"
                    card = JSON.parse(response.body)
                    return card
                else
                    puts "Failed to fetch card data. HTTP Status: #{response.code}
                    + \n Message: #{response.message}"
                    return nil
                end
            end

        rescue Timeout::Error => e
            puts "Request timed out while fetching card data."
            puts "Error: #{e.message}"
            return nil
        rescue Net::ReadTimeout => e
            puts "Network timeout error occurred while fetching card data."
            puts "Error: #{e.message}"
            return nil
        end
    end
end

