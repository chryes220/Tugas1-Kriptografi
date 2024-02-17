require 'singleton'
require_relative 'ciphers'

class Hill
  include Ciphers
  include Singleton

  # @key_matrix 

  def initialize
    puts "Hill Initialized"
    # @key_matrix = Array.new(5) { Array.new(5)}
  end

  def encrypt(plaintext,key)
    puts "Encrypting #{plaintext} using key #{key}"

    # #ubah key ke lowercase
    # key = key.downcase
    # # Buat matriks kunci
    # for i in 0..4 do
    #   for j in 0..4 do
    #     @key_matrix[i][j] = key[5*i+j].ord - 97
    #   end
    # end

    # # Buang karakter non alfabet
    # plaintext = plaintext.gsub(/[^a-zA-Z]/,"")
    # # Substitusi 'J' dengan 'i'
    # plaintext = plaintext.gsub(/[Jj]/,"i")

    # # Buat bigram
    # bigrams = [] # array of string
    # i = 0
    # while i < plaintext.length
    #   if i == plaintext.length-1  
    #     # tinggal sisa 1 huruf
    #     bigrams << plaintext[i].downcase + "x"
    #     i += 1
    #   elsif plaintext[i]!=plaintext[i+1] 
    #     bigrams << plaintext[i..i+1].downcase
    #     i += 2
    #   else
    #     bigrams << plaintext[i].downcase + "x"
    #     i += 1
    #   end
    # end

    # # lakukan enkripsi
    # ciphertext = ""
    # # place bigrams
    # for bigram in bigrams
    #   if is_same_row(bigram)
    #     # untuk kasus baris yang sama
    #     row = get_row(bigram[0])
    #     bigram.each_char do |char|
    #       ciphertext << (@key_matrix[get_row_idx(row)][(get_col_idx(char,row)+1) % 5]+97).chr
    #     end
    #   elsif is_same_col(bigram)
    #     # untuk kasus kolow yang sama
    #     col = get_col_idx(bigram[0],get_row(bigram[0]))
    #     bigram.each_char do |char|
    #       ciphertext << (@key_matrix[(get_row_idx(get_row(char))+1) %  5][col]+97).chr     
    #     end  
    #   else
    #     # untuk kasus baris dan kolom berbeda
    #     row_1 = get_row(bigram[0])
    #     row_2 = get_row(bigram[1])
    #     # karakter pertama, yang mana huruf pertama plaintext diganti dengan huruf pada perpotongan baris huruf pertama dengan kolom huruf kedua.
    #     ciphertext << (@key_matrix[get_row_idx(row_1)][get_col_idx(bigram[1],row_2)]+97).chr
    #     # karakter kedua (sisanya), yang mana huruf kedua plaintext diganti dengan huruf pada perpotongan kolom huruf pertama dengan baris huruf kedua.
    #     ciphertext << (@key_matrix[get_row_idx(row_2)][get_col_idx(bigram[0],row_1)]+97).chr
    #   end
    # end

    # puts "Ciphertext: #{ciphertext}"
    # # return hasil
    # return {result: ciphertext, result_base64: Base64.encode64(ciphertext)}
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

  # def is_same_row(bigram)
  #   rows = []
  #   bigram.each_char do |char|
  #     rows <<  get_row_idx(get_row(char))
  #   end
  #   # kalau sama semua, maka jika dibikin set akan memiliki panjang 1
  #   return rows.uniq.size == 1
  # end

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