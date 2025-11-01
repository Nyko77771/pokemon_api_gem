require 'pokemon_tcg_sdk'
require 'json'
require 'timeout'

class PokemonCard

    @api_key = ''

    def self.set_api_key(api_key)
        @api_key = api_key
    end

    def self.fetch_card_by_name(name)

=begin
        Pokemon.configure do |config|
            config.api_key = @api_key
        end
=end
        begin
            cards = nil
            Timeout.timeout(100) do
                cards = Pokemon::Card.where(q: "name:#{name}")
            end
        rescue Timeout::Error => e
            puts "Request timed out while fetching card data."
            puts "Error: #{e.message}"
            return nil
        rescue Net::ReadTimeout => e
            puts "Network read timeout occurred while fetching card data."
            puts "Error: #{e.message}"

            return nil
        end  

        if cards.nil? || cards.empty?
            puts "No card found with the name #{name}"
            return nil
        end

        puts "Cards found"

        #return cards

        card = cards.first
        if card
        puts JSON.pretty_generate(JSON.parse(card.to_json))
        puts "Card: #{card.name}"
        value = card.cardmarket.prices
        puts "Subtypes: #{card.types.join(', ')}"
        puts "HP: #{card.hp}"
        puts "Evolves From: #{card.evolves_from}"
        puts "Attacks: #{card.attacks.join(', ')}"
        puts "Set: #{card.set.name}"
        
            if value
                puts "  Average Sell Price: #{value.averageSellPrice}"
                puts "  Low Price: #{value.lowPrice}"
                puts "  Trend Price: #{value.trendPrice}"
            else
                puts "  No price information available."
            end
        else
            puts "  No price information available."
        end
    end
end