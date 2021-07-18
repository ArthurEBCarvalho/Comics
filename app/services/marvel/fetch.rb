module Marvel
  class Fetch
    BASE_URL           = 'https://gateway.marvel.com:443/v1/public'
    MARVEL_PUBLIC_KEY  = ENV.fetch('MARVEL_PUBLIC_KEY', '')
    MARVEL_PRIVATE_KEY = ENV.fetch('MARVEL_PRIVATE_KEY', '')
    TIMESTAMP          = '1'
    PER_PAGE           = 20

    class << self
      def comics(character_name: nil, page: 1)
        response = if character_name.present?
                     Faraday.get(url('/comics'), params(page, characters: fetch_character_id(character_name)), headers)
                   else
                     Faraday.get(url('/comics'), params(page), headers)
                   end
        
        raise_error(response) unless response.status.between?(200, 299)

        JSON.parse(response.body).dig('data', 'results')
      rescue Faraday::ConnectionFailed => e
        raise Marvel::RequestError.new(e.message, status: 500)
      end

      private

      def fetch_character_id(character_name)
        response = Faraday.get(url('/characters'), params(1, { name: character_name, limit: 1 }), headers)
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

      def params(page, params = {})
        {
          ts:     TIMESTAMP,
          apikey: MARVEL_PUBLIC_KEY,
          hash:   Digest::MD5.hexdigest("#{TIMESTAMP}#{MARVEL_PRIVATE_KEY}#{MARVEL_PUBLIC_KEY}"),
          orderBy: 'focDate'
        }.merge(pagination(page)).merge(params)
      end
      
      def raise_error(response)
        data          = JSON.parse(response.body)
        error_message = data.dig('error') || data.dig('errors')

        raise Marvel::RequestError.new(error_message, status: response.status)
      end

      def pagination(page)
        offset = (page - 1) * PER_PAGE
        offset = 0 if offset.negative?

        { limit: PER_PAGE, offset: offset }
      end
    end
  end
end