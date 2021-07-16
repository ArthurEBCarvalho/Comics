module Marvel
  class Fetch
    BASE_URL           = 'https://gateway.marvel.com:443/v1/public'
    MARVEL_PUBLIC_KEY  = ENV.fetch('MARVEL_PUBLIC_KEY', '')
    MARVEL_PRIVATE_KEY = ENV.fetch('MARVEL_PRIVATE_KEY', '')
    TIMESTAMP          = '1'

    class << self
      def comics(character_name = nil)
        response = if character_name.present?
                     Faraday.get(url('/comics'), params({ orderBy: 'focDate', characters: fetch_character_id(character_name) }), headers)
                   else
                     Faraday.get(url('/comics'), params({ orderBy: 'focDate' }), headers)
                   end
        
        raise_error(response) unless response.status.between?(200, 299)

        JSON.parse(response.body).dig('data', 'results')
      rescue Faraday::ConnectionFailed => e
        raise Marvel::RequestError.new(e.message, status: 500)
      end

      private

      def fetch_character_id(character_name)
        response = Faraday.get(url('/characters'), params({ name: character_name }), headers)
        raise_error(response) unless response.status.between?(200, 299)

        JSON.parse(response.body).dig('data', 'results', 0, 'id')
      end

      def url(endpoint)
        BASE_URL + endpoint
      end

      def headers(contents = {})
        {
          Accept:           'application/json',
          'Content-Type' => 'application/json'
        }
      end

      def params(params = {})
        {
          ts:     TIMESTAMP,
          apikey: MARVEL_PUBLIC_KEY,
          hash:   Digest::MD5.hexdigest("#{TIMESTAMP}#{MARVEL_PRIVATE_KEY}#{MARVEL_PUBLIC_KEY}")
        }.merge(params)
      end
      
      def raise_error(response)
        data          = JSON.parse(response.body)
        error_message = data.dig('error') || data.dig('errors')

        raise Marvel::RequestError.new(error_message, status: response.status)
      end
    end
  end
end