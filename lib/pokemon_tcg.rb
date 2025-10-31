require 'pokemon_tcg_sdk'
require 'json'


module Pokemon
    class << self

        if defined?(connection)
            alias_method :original_connection, :connection

            def connection
                this_connection = original_connection
                this_connection.options.timeout = 10
                this_connection.options.open_timeout = 10
                this_connection
            end
        end
    end
end


class PokemonCard

    @api_key = ''

    def self.set_api_key(api_key)
        @api_key = api_key
    end

    def self.fetch_card_by_name(name)

        Pokemon.configure do |config|
            config.api_key = @api_key
        end

        cards = Pokemon::Card.where(q: "name:#{name}")

        unless cards.is_a?(Array)
            puts "Unexpected response format"
            return nil
        end

        if cards.nil? || cards.empty?
            puts "No card found with the name #{name}"
            return nil
        end

        puts "Card found: #{cards.first.name}"

        #card = cards.first

        #return cards

        for card in cards
            if card.cardmarket
            puts "Name: #{card.name}"
            puts "Supertype: #{card.supertype}"
            puts "Subtypes: #{card.subtypes.join(', ')}"
            puts "HP: #{card.hp}"
            #puts "Types: #{card.types.join(', ')}"
            puts "Price Info:"
            puts card.cardmarket.class
            else
                puts "  No price information available."
            end
        end
    end
end