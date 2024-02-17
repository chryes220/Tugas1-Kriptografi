require 'singleton'
require_relative 'ciphers'

class Transposition 
  include Singleton
  include Ciphers

  # any character is fine for transposition, therefore there will be no sanitations

  def initialize
    puts "Transposition initialized"
  end

  def encrypt(plaintext, key)
    # assuming key is a number which represents the number of columns
    puts "Encrypting #{plaintext} using key #{key}"

    key = key.to_i
    padding = "abcdefghijklmnopqrstuvwxyz"

    if plaintext.length % key != 0
      plaintext += padding[0..(key - plaintext.length % key - 1)]
    end

    puts "Padded plaintext: #{plaintext}"

    # for 0..key-1, create a string of characters from plaintext
    # with an interval of key
    ciphertext = ""
    key.times do |i|
      j = i
      while j < plaintext.length
        ciphertext += plaintext[j]
        j += key
      end
    end

    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext, key)
    puts "Decrypting #{ciphertext} using key #{key}"

    key = key.to_i
    padding = "abcdefghijklmnopqrstuvwxyz"
    blocks = ciphertext.length / key

    # for 0..blocks-1, create a string of characters from ciphertext
    # with an interval of blocks
    plaintext = ""
    blocks.times do |i|
      j = i
      while j < ciphertext.length
        plaintext += ciphertext[j]
        j += blocks
      end
    end

    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end

end