require 'singleton'
require_relative 'ciphers'

class Enigma
  include Ciphers
  include Singleton

  @rotor_1
  @rotor_2
  @rotor_3
  @pos_1
  @pos_2
  @pos_3

  def initialize
    puts "Enigma Initialized"
  end

  def encrypt(plaintext,key)
    # parse input
    keysets, configurations = key.gsub(/ /,"").split(";")
    # parse keysets
    @rotor_1, @rotor_2, @rotor_3 = keysets.downcase.split(',')
    # parse starting positions
    @pos_1, @pos_2, @pos_3 = configurations.split(",").map{|e| e.to_i}

    puts "Encrypting #{plaintext} using configuration `#{keysets}` and starting positions #{configurations}"

    # Buang karakter non alfabet di plaintext
    plaintext = plaintext.gsub(/[^a-zA-Z]/,"")
    # konversi ke huruf kecil
    plaintext = plaintext.downcase

    # inisialisasi
    # lakukan enkripsi
    ciphertext = ""

    plaintext.each_char do |char|
      temp_1 = @rotor_1[(char.ord()-97 + @pos_1) % 26]
      temp_2 = @rotor_2[(temp_1.ord()-97 + @pos_2) % 26]
      ciphertext << @rotor_3[(temp_2.ord()-97 + @pos_3) % 26]

      # geser posisi
      # geser rotor 3
      @pos_3 = (@pos_3+1)%26
      if @pos_3 == 0
        # geser rotor 2 bila rotor 3 dah muter 1 siklus (26 kali)
        @pos_2 = (@pos_2+1)%26
        if @pos_2 ==0
          # geser rotor 1 bila rotor 2 dah muter 1 siklus (26 kali)
          @pos_1 = (@pos_1+1) % 26
        end
      end
    end

    puts "Ciphertext: #{ciphertext}"
    # # return hasil
    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext,key)
    # parse input
    keysets, configurations = key.gsub(/ /,"").split(";")
    # parse keysets
    @rotor_1, @rotor_2, @rotor_3 = keysets.downcase.split(',')
    # parse starting positions
    @pos_1, @pos_2, @pos_3 = configurations.split(",").map{|e| e.to_i}

    puts "Decrypting #{ciphertext} using configuration `#{keysets}` and starting positions #{configurations}"

    # Buang karakter non alfabet di ciphertext
    ciphertext = ciphertext.gsub(/[^a-zA-Z]/,"")
    # konversi ke huruf kecil
    ciphertext = ciphertext.downcase

    # inisialisasi
    # lakukan dekripsi
    plaintext = ""

    ciphertext.each_char do |char|
      temp_3 = (((@rotor_3.index(char) - @pos_3) % 26) + 97).chr
      temp_2 = (((@rotor_2.index(temp_3) - @pos_2) % 26) + 97).chr
      plaintext << (((@rotor_1.index(temp_2) - @pos_1) % 26) + 97).chr

      # geser posisi
      # geser rotor 3
      @pos_3 = (@pos_3+1)%26
      if @pos_3 == 0
        # geser rotor 2 bila rotor 3 dah muter 1 siklus (26 kali)
        @pos_2 = (@pos_2+1)%26
        if @pos_2 ==0
          # geser rotor 1 bila rotor 2 dah muter 1 siklus (26 kali)
          @pos_1 = (@pos_1+1) % 26
        end
      end
    end

    puts "Plaintext: #{plaintext}"
    # return hasil
    return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end
end