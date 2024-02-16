class PagesController < ApplicationController
  def index
  end

  def submit
    act = params[:act]
    cipher = params[:cipher]
    message = params[:message]
    key = params[:key]

    case cipher
    when "standard-vigenere"
      cipher_class = StandardVigenere.instance
      if act == "encrypt"
        cipher_class.encrypt(message, key)
      else
        cipher_class.decrypt(message, key)
      end
    # ...
    end

  end

  
end
