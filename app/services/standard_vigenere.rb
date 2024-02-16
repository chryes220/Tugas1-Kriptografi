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
  end

  def decrypt(text)
    puts "Decrypting #{text} using key #{key}"
  end
end
