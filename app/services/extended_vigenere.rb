require 'singleton'
require_relative 'ciphers'

class ExtendedVigenere
  include Singleton
  include Ciphers

  def initialize
    puts "ExtendedVigenere initialized"
  end

  def encrypt(plaintext, key)
    puts "Encrypting #{plaintext} using key #{key}"

    if key.length < plaintext.length
      key = key * (plaintext.length / key.length + 1)
    end

    ciphertext = ""
    plaintext.each_char.with_index do |char, index|
      char = char.ord
      key_char = key[index % key.length].ord
      ciphertext += ((char + key_char) % 256).chr
    end

    # check if ciphertext includes non-printable characters
    ciphertext_base64 = Base64.encode64(ciphertext)
    if ciphertext.match?(/[^[:print:]]/)
      ciphertext = "Ciphertext contains non-printable characters."
    end

    return {result: ciphertext, result_base64: ciphertext_base64}
  end

  def decrypt(ciphertext, key)
    puts "Decrypting #{ciphertext} using key #{key}"

    plaintext = ""
    ciphertext.each_char.with_index do |char, index|
      char = char.ord
      key_char = key[index % key.length].ord
      plaintext += ((char - key_char) % 256).chr
    end

    puts "Plaintext: #{plaintext}"
    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end
end