class PagesController < ApplicationController
  def index
  end

  def submit
    act = params[:act]
    cipher = params[:cipher]
    message = params[:message]
    key = params[:key]

    cipher_class = nil
    result = {}

    case cipher
      when "standard-vigenere"
        cipher_class = StandardVigenere.instance
      when "auto-key-vigenere"
        cipher_class = nil
      when "extended-vigenere"
        cipher_class = ExtendedVigenere.instance

      # ...
    end
    
    if act == "encrypt"
      result = cipher_class.encrypt(message, key)
    else
      result = cipher_class.decrypt(message, key)
    end

    render json: result

  end

  
end
