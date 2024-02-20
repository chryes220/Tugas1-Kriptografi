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
    # # parse key
    # temp_token = key.split(';')
    # # get m (dimension)
    # @m = temp_token[0].to_i
    # # parse key matrix
    # parse_key_matrix(temp_token[-1])
    # # inverskan matriks kunci
    # inverse_matrix()

    # puts "Decrypting #{ciphertext} using key #{key}"

    # # Buang karakter non alfabet
    # ciphertext = ciphertext.gsub(/[^a-zA-Z]/,"")
    # # konversi ke huruf kecil
    # ciphertext = ciphertext.downcase
    # # lakukan enkripsi
    # plaintext = ""
    # i = 0
    # ciphertext_array = Array.new(@m,0)
    # while i < ciphertext.length
    #   # buat array berisi ciphertext dalam nilai ASCII relatif terhadap 'a'
    #   if i+@m > ciphertext.length
    #     offset = ciphertext.length-i
    #     for j in 0...offset do
    #       ciphertext_array[j] = (ciphertext[j+i].ord)-97
    #     end
    #     # kurang karakter, kasih padding
    #     for j in offset...@m do
    #       ciphertext_array[j] = 0
    #     end
    #   else
    #     for j in 0...@m do
    #       ciphertext_array[j] = (ciphertext[j+i].ord)-97
    #     end
    #   end
    #   # konversi array ke matriks kolom
    #   ciphertext_column_vector = Matrix.column_vector(ciphertext_array)
    #   # kalikan dengan matriks kunci dengan rumus C = KP
    #   result_matrix = @key_matrix * ciphertext_column_vector
    #   # konversikan ke plaintext
    #   plaintext << result_matrix.to_a.flatten.map { |element| ((element % 26) + 97).chr }.join
    #   i += @m
    # end

    # puts "Plaintext: #{plaintext}"
    # # return hasil
    # return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end

  # def parse_key_matrix(key)
  #   # sanitasi key matrix
  #   key = key.gsub(/[^\d\[\] ,]/,"")
  #   # konversi string jadi matrix
  #   converted_array = eval(key)
  #   @key_matrix = Matrix[*converted_array]
  # end

  # def inverse_matrix()
  #   # persamaan invers hill cipher: (KK^(-1)) mod 26 == I 
  #   # persamaan determinannya: (det(K)* det(1/K)) mod 26 = 1
  #   # (a*b) mod 26 = a mod 26 * b mod 26
  #   # det(K) mod 26 * det(1/K) mod 26 = 1
  #   # persamaan umum mencari invers: K^(-1) = adj(K)/det(K) = adj(K) * det(1/K)
  #   det = @key_matrix.det % 26
  #   # cari determinan matriks invers (invers dari det(K))
  #   det_inv = 0
  #   loop do
  #     break if (det * det_inv) % 26 == 1
  #     det_inv += 1
  #   end
  #   # cari adjoin matrix
  #   adj_matrix = @key_matrix.adjugate
  #   # K^(-1) = adj(K) * det(1/K)
  #   # modulokan tiap elemen matriks dengan 26, kalikan dengan determinan K^(-1), lalu di modulokan lagi dengan 26
  #   @key_matrix = adj_matrix.map{|e| ((e%26)*det_inv)%26}
  # end
end