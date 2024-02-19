require_relative "../services/standard_vigenere.rb"
require_relative "../services/autokey_viginere.rb"
require_relative "../services/extended_vigenere.rb"
require_relative "../services/playfair.rb"
require_relative "../services/hill.rb"
require_relative "../services/enigma.rb"

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
    input_type = params[:input_type]

    cipher_class = nil
    result = {}

    # if input is file, parse it first
    if input_type == "fileInput"
      if cipher=="extended-vigenere"
        # Extended Viginere dibasa as binary
        message = IO.binread(params[:file].tempfile)
      else
        # Selain itu dibaca as text
        message = params[:file].tempfile.read()
      end
    end

    # if format is base64, decode message
    if msg_format == "base64"
      message = Base64.decode64(message)
    end
    if key_format == "base64"
      if cipher == "affine" || cipher == "se-xvigenere-transpose " || cipher == "se-transpose-xvigenere"
        key_arr = key.split(",")
        key = Base64.decode64(key_arr[0]) + "," + Base64.decode64(key_arr[1])
      else
        key = Base64.decode64(key)
      end
    end

    puts "Message: #{message}"
    puts "Key: #{key}"

    # if cipher starts with "se-"
    if !cipher.start_with?("se-")
      case cipher
        when "standard-vigenere"
          cipher_class = StandardVigenere.instance
        when "auto-key-vigenere"
          cipher_class = AutokeyViginere.instance
        when "extended-vigenere"
          cipher_class = ExtendedVigenere.instance
        when "playfair"
          cipher_class = Playfair.instance
        when "affine"
          cipher_class = Affine.instance
        when "transposition"
          cipher_class = Transposition.instance
        when "hill"
          cipher_class = Hill.instance
        when "enigma"
          cipher_class = Enigma.instance
      end
      
      if act == "encrypt"
        result = cipher_class.encrypt(message, key)
      else
        result = cipher_class.decrypt(message, key)
      end
    else 
      key_arr = key.split(",")
      puts "Key for super encryption: #{key_arr[0]}, #{key_arr[1]}"
      if cipher == "se-xvigenere-transpose"
        if act == "encrypt"
          result = Transposition.instance.encrypt(ExtendedVigenere.instance.encrypt(message, key_arr[0])[:result], key_arr[1])
        else
          result = ExtendedVigenere.instance.decrypt(Transposition.instance.decrypt(message, key_arr[1])[:result], key_arr[0])

          # remove tailing unprintable characters
          result[:result] = result[:result].gsub(/[^[:print:]]+$/, "")
          result[:result_base64] = Base64.encode64(result[:result])
        end
      else
        if act == "encrypt"
          result = ExtendedVigenere.instance.encrypt(Transposition.instance.encrypt(message, key_arr[1])[:result], key_arr[0])
        else
          result = Transposition.instance.decrypt(ExtendedVigenere.instance.decrypt(message, key_arr[0])[:result], key_arr[1])

          # remove tailing unprintable characters
          result[:result] = result[:result].gsub(/[^[:print:]]+$/, "")
          result[:result_base64] = Base64.encode64(result[:result])
        end
      end
    end

    if result[:result].match?(/[^[:print:]]/)
      result[:result] = "Result contains non-printable characters."
    end

    render json: result

  end

  
end
