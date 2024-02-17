require 'singleton'
require_relative 'ciphers'

class Affine
  include Singleton
  include Ciphers

  def initialize
    puts "Affine initialized"
  end

  def encrypt(plaintext, key)
    puts "Encrypting #{plaintext} using key #{key}"

    a, b = key.split(",").map(&:to_i)
    ciphertext = ""

    # remove non-alphabetic characters
    plaintext = plaintext.gsub(/[^a-zA-Z]/, "")

    plaintext.each_char do |char|
      char = char.downcase.ord
      if char >= 97 && char <= 122
        char = ((a * (char - 97) + b) % 26 + 97).chr
      end
      ciphertext += char
    end

    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext, key)
    puts "Decrypting #{ciphertext} using key #{key}"

    a, b = key.split(",").map(&:to_i)
    a_inv = 0
    stop = false
    while !stop && a_inv < 26
      if (a * a_inv) % 26 == 1
        stop = true
      else
        a_inv += 1
      end
    end
    
    plaintext = ""

    # remove non-alphabetic characters
    ciphertext = ciphertext.gsub(/[^a-zA-Z]/, "")

    ciphertext.each_char do |char|
      char = char.downcase.ord
      if char >= 97 && char <= 122
        char = ((a_inv * (char - 97 - b + 26)) % 26 + 97).chr
      end
      plaintext += char
    end

    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end

end