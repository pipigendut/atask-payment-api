require 'securerandom'
require 'base64'
require 'json'
require 'openssl'

module Auth
  class AuthManager
    EXPIRATION_TIME = 24.hours
    SECRET_KEY = ENV.fetch('JWT_KEY', 'jwt_key')

    def self.generate_token(user_id, type)
      payload = {
        user_id: user_id,
        type: type,
        exp: (Time.now + EXPIRATION_TIME).to_i
      }
      # Convert payload to JSON
      encoded_payload = Base64.urlsafe_encode64(payload.to_json)
      signature = generate_signature(encoded_payload) # Generate signature from encoded payload
      "#{encoded_payload}.#{signature}" # Include the signature for verification
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

      expected_signature = parts[1]
      generate_signature(parts[0]) == expected_signature # Compare generated signature
    rescue JSON::ParserError
      false
    end

    private

    def self.generate_signature(encoded_payload)
      # Use HMAC with SHA256 for signature generation
      hmac = OpenSSL::HMAC.digest('SHA256', SECRET_KEY, encoded_payload)
      Base64.urlsafe_encode64(hmac)
    end
  end
end
