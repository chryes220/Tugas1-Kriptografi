require 'singleton'
require_relative 'ciphers'

class StandardVigenere 
  include Ciphers 
  include Singleton

  def initialize
    puts "StandardVigenere initialized"
  end

  def encrypt(plaintext, key)
    puts "Encrypting #{plaintext} using key #{key}"

    # check if key length is shorter than plaintext, if so repeat key
    if key.length < plaintext.length
      key = key * (plaintext.length / key.length + 1)
    end

    space_indices = []
    plaintext.each_char.with_index do |char, index|
      space_indices << index if char == " "
    end

    # insert spaces to key in the same indices as the plaintext
    space_indices.each do |index|
      key = key[0...index] + " " + key[index..-1]
    end
    puts "Preprocessed Key: #{key}"

    # encrypt
    ciphertext = ""
    plaintext.each_char.with_index do |char, index|
      char = char.upcase
      key_char = key[index].upcase
      if char.ord >= 65 && char.ord <= 90
        ciphertext += (((char.ord - 65 + key_char.ord - 65) % 26) + 65).chr
      else
        ciphertext += char
      end
    end

    puts "Ciphertext: #{ciphertext}"
    return ciphertext
  end

  def decrypt(ciphertext, key)
    puts "Decrypting #{ciphertext} using key #{key}"

    # check if key length is shorter than ciphertext, if so repeat key
    if key.length < ciphertext.length
      key = key * (ciphertext.length / key.length + 1)
    end

    space_indices = []
    ciphertext.each_char.with_index do |char, index|
      space_indices << index if char == " "
    end

    # insert spaces to key in the same indices as the ciphertext
    space_indices.each do |index|
      key = key[0...index] + " " + key[index..-1]
    end
    puts "Preprocessed Key: #{key}"

    # decrypt
    plaintext = ""
    ciphertext.each_char.with_index do |char, index|
      char = char.upcase
      key_char = key[index].upcase
      if char.ord >= 65 && char.ord <= 90
        plaintext += (((char.ord - 65 - key_char.ord - 65) % 26) + 65).chr
      else
        plaintext += char
      end
    end

    puts "Plaintext: #{plaintext}"
    return plaintext
  end
end
