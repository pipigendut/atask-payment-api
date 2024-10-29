require 'securerandom'
require 'base64'

module Auth
  class AuthManager
    EXPIRATION_TIME = 24.hours

    def self.generate_token(user_id, user_type)
      payload = {
        user_id: user_id,
        user_type: user_type,
        exp: (Time.now + EXPIRATION_TIME).to_i
      }
      # Convert payload to JSON and then encode it to base64
      token = Base64.urlsafe_encode64(payload.to_json)
      "#{token}.#{generate_signature(payload)}" # Include a signature for verification
    end

    def self.decode_token(token)
      return nil unless token_valid?(token)

      # Split the token to get the payload part
      encoded_payload = token.split('.').first
      payload = JSON.parse(Base64.urlsafe_decode64(encoded_payload))
      payload
    rescue JSON::ParserError
      nil
    end

    def self.token_valid?(token)
      return false unless token

      # Check if the token is correctly formed
      parts = token.split('.')
      return false unless parts.size == 2

      payload = JSON.parse(Base64.urlsafe_decode64(parts[0]))
      return false if payload['exp'].to_i < Time.now.to_i # Check expiration

      expected_signature = generate_signature(payload)
      expected_signature == parts[1]
    rescue JSON::ParserError
      false
    end

    private

    def self.generate_signature(payload)
      # Create a simple signature using SecureRandom (or a hash of your choice)
      SecureRandom.hex(16) # In a real application, you'd use a more secure method
    end
  end
end
