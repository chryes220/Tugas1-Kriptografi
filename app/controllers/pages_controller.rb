require_relative "../services/standard_vigenere.rb"
require_relative "../services/autokey_viginere.rb"
require_relative "../services/extended_vigenere.rb"
require_relative "../services/playfair.rb"

class PagesController < ApplicationController
  def index
  end

  def submit
    act = params[:act]
    cipher = params[:cipher]
    message = params[:message]
    key = params[:key]
    msg_format = params[:group_msg]
    key_format = params[:group_key]

    cipher_class = nil
    result = {}

    # if format is base64, decode message
    if msg_format == "base64"
      message = Base64.decode64(message)
    end
    if key_format == "base64"
      key = Base64.decode64(key)
    end
    puts "Message: #{message}"
    puts "Key: #{key}"

    case cipher
      when "standard-vigenere"
        cipher_class = StandardVigenere.instance
      when "auto-key-vigenere"
        cipher_class = AutokeyViginere.instance
      when "extended-vigenere"
        cipher_class = ExtendedVigenere.instance
      when "playfair"
        cipher_class = Playfair.instance
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
