module Ciphers
  def encrypt(plaintext, key)
    raise NotImplementedError, 'This is an abstract method. Please implement it in a subclass.'
  end

  def decrypt(ciphertext, key)
    raise NotImplementedError, 'This is an abstract method. Please implement it in a subclass.'
  end
end