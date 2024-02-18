require 'singleton'
require 'matrix'
require_relative 'ciphers'

class Hill
  include Ciphers
  include Singleton

  @key_matrix 
  @m

  def initialize
    puts "Hill Initialized"
  end

  def encrypt(plaintext,key)
    # parse key
    temp_token = key.split(';')
    # get m (dimension)
    @m = temp_token[0].to_i
    # parse key matrix
    parse_key_matrix(temp_token[-1])

    puts "Encrypting #{plaintext} using key `#{key}`"

    # Buang karakter non alfabet
    plaintext = plaintext.gsub(/[^a-zA-Z]/,"")
    # konversi ke huruf kecil
    plaintext = plaintext.downcase
    # lakukan enkripsi
    ciphertext = ""
    i = 0
    plaintext_array = Array.new(@m,0)
    while i < plaintext.length
      # buat array berisi plaintext dalam nilai ASCII relatif terhadap 'a'
      if i+@m > plaintext.length
        offset = plaintext.length-i
        for j in 0...offset do
          plaintext_array[j] = (plaintext[j+i].ord)-97
        end
        # kurang karakter, kasih padding
        for j in offset...@m do
          plaintext_array[j] = 0
        end
      else
        for j in 0...@m do
          plaintext_array[j] = (plaintext[j+i].ord)-97
        end
      end
      # konversi array ke matriks kolom
      plaintext_column_vector = Matrix.column_vector(plaintext_array)
      # kalikan dengan matriks kunci dengan rumus C = KP
      result_matrix = @key_matrix * plaintext_column_vector
      # konversikan ke ciphertext
      ciphertext << result_matrix.to_a.flatten.map { |element| ((element % 26) + 97).chr }.join
      i += @m
    end

    puts "Ciphertext: #{ciphertext}"
    # # return hasil
    return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
  end

  def decrypt(ciphertext,key)
    puts "Decrypting #{ciphertext} using key #{key}"

  #   #ubah key ke lowercase
  #   key = key.downcase
  #   # Buat matriks kunci
  #   for i in 0..4 do
  #     for j in 0..4 do
  #       @key_matrix[i][j] = key[5*i+j].ord - 97
  #     end
  #   end

  #   # Buang karakter non alfabet
  #   ciphertext = ciphertext.gsub(/[^a-zA-Z]/,"")
  #   # Substitusi 'J' dengan 'i'
  #   ciphertext = ciphertext.gsub(/[Jj]/,"i")

  #   # Buat bigram
  #   bigrams = [] # array of string
  #   i = 0
  #   while i < ciphertext.length
  #     if i == ciphertext.length-1  
  #       # tinggal sisa 1 huruf
  #       bigrams << ciphertext[i].downcase + "x"
  #       i += 1
  #     elsif ciphertext[i]!=ciphertext[i+1] 
  #       bigrams << ciphertext[i..i+1].downcase
  #       i += 2
  #     else
  #       bigrams << ciphertext[i].downcase + "x"
  #       i += 1
  #     end
  #   end

  #   # lakukan enkripsi
  #   plaintext = ""
  #   # place bigrams
  #   for bigram in bigrams
  #     if is_same_row(bigram)
  #       # untuk kasus baris yang sama
  #       row = get_row(bigram[0])
  #       bigram.each_char do |char|
  #         plaintext << (@key_matrix[get_row_idx(row)][(get_col_idx(char,row)-1) % 5]+97).chr
  #       end
  #     elsif is_same_col(bigram)
  #       # untuk kasus kolow yang sama
  #       col = get_col_idx(bigram[0],get_row(bigram[0]))
  #       bigram.each_char do |char|
  #         plaintext << (@key_matrix[(get_row_idx(get_row(char))-1) %  5][col]+97).chr     
  #       end  
  #     else
  #       # untuk kasus baris dan kolom berbeda
  #       row_1 = get_row(bigram[0])
  #       row_2 = get_row(bigram[1])
  #       # karakter pertama, yang mana huruf pertama plaintext diganti dengan huruf pada perpotongan baris huruf pertama dengan kolom huruf kedua.
  #       plaintext << (@key_matrix[get_row_idx(row_1)][get_col_idx(bigram[1],row_2)]+97).chr
  #       # karakter kedua (sisanya), yang mana huruf kedua plaintext diganti dengan huruf pada perpotongan kolom huruf pertama dengan baris huruf kedua.
  #       plaintext << (@key_matrix[get_row_idx(row_2)][get_col_idx(bigram[0],row_1)]+97).chr
  #     end
  #   end

  #   puts "Plaintext: #{plaintext}"
  #   # return hasil
  #   return {result: plaintext, result_base64: Base64.encode64(plaintext)}
  end

  def parse_key_matrix(key)
    # sanitasi key matrix
    key = key.gsub(/[^\d\[\] ,]/,"")
    # konversi string jadi matrix
    converted_array = eval(key)
    @key_matrix = Matrix[*converted_array]
  end

  # def is_same_col(bigram)
  #   cols = []
  #   bigram.each_char do |char|
  #     cols << get_col_idx(char,get_row(char))
  #   end
  #   # kalau sama semua, maka jika dibikin set akan memiliki panjang 1
  #   return cols.uniq.size == 1
  # end

  # def get_row(element)
  #   row = @key_matrix.detect{|line| line.include?(element.ord() -97)}
  #   return row
  # end

  # def get_row_idx(row)
  #   return @key_matrix.index(row)
  # end

  # def get_col_idx(element,row)
  #   return row.index(element.ord-97) 
  # end

end