require 'singleton'
require_relative 'ciphers'

class ExtendedVigenere
  include Singleton
  include Ciphers

  def initialize
    puts "ExtendedVigenere initialized"
  end

  def encrypt(plaintext, key)
    if key.length < plaintext.length
      key = key * (plaintext.length / key.length + 1)
    end

    ciphertext = ""
    plaintext.each_char.with_index do |char, index|
      char = char.ord
      key_char = key[index % key.length].ord
      ciphertext += ((char + key_char) % 256).chr
    end

    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext, key)
    plaintext = ""
    ciphertext.each_char.with_index do |char, index|
      char = char.ord
      key_char = key[index % key.length].ord
      plaintext += ((char - key_char) % 256).chr
    end
    
    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end
end