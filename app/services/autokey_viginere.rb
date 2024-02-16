require 'singleton'
require_relative 'ciphers'

class AutokeyViginere
  include Ciphers
  include Singleton

  def initialize
    puts "Auto-Key Viginere Initialized"
  end

  def encrypt(plaintext,key)
    puts "Encrypting #{plaintext} using key #{key}"

    # Buang karakter non alfabet
    plaintext = plaintext.gsub(/[^a-zA-Z]/,"")
    key = key.gsub(/[^a-zA-Z]/,"")

    # Bila panjang key < plaintext, tambahkan potongan plaintext ke key sampai panjangnya sama
    if key.length < plaintext.length
      key << plaintext[0, plaintext.length-key.length] 
    end

    # lakukan enkripsi
    ciphertext = ""
    plaintext.each_char.with_index do |char,index|
      char = char.downcase
      key_char = key[index].downcase
      # mestinya dah kesanitasi semua di awal
      ciphertext += (((char.ord-97 + key_char.ord-97) % 26) + 97).chr
    end

    puts "Ciphertext: #{ciphertext}"
    # return hasil
    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext,key)
    puts "Decrypting #{ciphertext} using key #{key}"

    # Buang karakter non alfabet
    ciphertext = ciphertext.gsub(/[^a-zA-Z]/,"")
    key = key.gsub(/[^a-zA-Z]/,"")   

    # Bila panjang key < ciphertext, tambahkan potongan ciphertext ke key sampai panjangnya sama
    if key.length < ciphertext.length
      key << ciphertext[0, ciphertext.length-key.length] 
    end
    
    # lakukan dekripsi
    plaintext = ""
    ciphertext.each_char.with_index do |char,index|
      char = char.downcase
      key_char = key[index].downcase
      # mestinya dah kesanitasi semua di awal
      plaintext += (((char.ord - key_char.ord) % 26) + 97).chr
    end
    puts "Plaintext: #{plaintext}"
    # Lu harus masukin kunci yang sama persis buat decrypt karena mana tau ini cipher kunci plaintextnya bjir
    # return hasil
    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end
end