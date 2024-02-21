require 'singleton'
require_relative 'ciphers'

class StandardVigenere 
  include Ciphers 
  include Singleton

  def initialize
    puts "StandardVigenere initialized"
  end

  def encrypt(plaintext, key)
    # remove non-alphabetic characters
    plaintext = plaintext.gsub(/[^a-zA-Z]/, "")

    # check if key length is shorter than plaintext, if so repeat key
    if key.length < plaintext.length
      key = key * (plaintext.length / key.length + 1)
    end

    # encrypt
    ciphertext = ""
    plaintext.each_char.with_index do |char, index|
      char = char.downcase
      key_char = key[index].downcase
      if char.ord >= 97 && char.ord <= 122
        ciphertext += (((char.ord - 97 + key_char.ord - 97) % 26) + 97).chr
      else
        ciphertext += char
      end
    end

    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)} 
  end

  def decrypt(ciphertext, key)
    # remove non-alphabetic characters
    ciphertext = ciphertext.gsub(/[^a-zA-Z]/, "")

    # check if key length is shorter than ciphertext, if so repeat key
    if key.length < ciphertext.length
      key = key * (ciphertext.length / key.length + 1)
    end

    # decrypt
    plaintext = ""
    ciphertext.each_char.with_index do |char, index|
      char = char.downcase
      key_char = key[index].downcase
      if char.ord >= 97 && char.ord <= 122
        plaintext += (((char.ord - key_char.ord) % 26) + 97).chr
      else
        plaintext += char
      end
    end
    
    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end
end
