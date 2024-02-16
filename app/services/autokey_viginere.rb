require 'singleton'
require_relative 'ciphers'

class AutokeyViginere
  include Ciphers
  include Singleton

  def initialize
    puts "Auto-Key Viginere Initialized"
  end

  def encrypt(plaintext,key)
  end

  def decrypt(ciphertext,key)
  end
end