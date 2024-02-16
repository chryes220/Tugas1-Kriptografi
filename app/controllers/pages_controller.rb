class PagesController < ApplicationController
  def index
  end

  def submit
    act = params[:act]
    cipher = params[:cipher]
    message = params[:message]
    key = params[:key]

    cipher_class = nil
    result = ""

    case cipher
      when "standard-vigenere"
        cipher_class = StandardVigenere.instance
        if act == "encrypt"
          result = cipher_class.encrypt(message, key)
        else
          result = cipher_class.decrypt(message, key)
        end
      # ...
    end

    render json: { result: result }

  end

  
end
