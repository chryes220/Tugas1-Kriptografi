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

    puts "input_type: #{input_type}"

    cipher_class = nil
    result = {}
    file_name = "result.txt"

    is_cipher_256 = if cipher == "extended-vigenere" || cipher.start_with?("se-") || cipher == "transposition" then true else false end

    # if input is file, parse it first
    if input_type == "fileInput"
      if is_cipher_256
        # Jika cipher adalah extended-vigenere atau super-encryption, maka file dibaca sebagai binary
        message = IO.binread(params[:file].tempfile)
      else
        # Selain itu dibaca as text
        message = params[:file].tempfile.read()
      end
    elsif msg_format == "base64" # message is text input in base64
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

      if cipher == "se-xvigenere-transpose"
        if act == "encrypt"
          result = Transposition.instance.encrypt(ExtendedVigenere.instance.encrypt(message, key_arr[0])[:result], key_arr[1])
        else
          result = ExtendedVigenere.instance.decrypt(Transposition.instance.decrypt(message, key_arr[1])[:result], key_arr[0])

          # remove tailing unprintable characters if input is text
          if input_type == "textInput"
            result[:result] = result[:result].tr('^ -~', '')
            result[:result_base64] = Base64.encode64(result[:result])
          end
        end
      else
        if act == "encrypt"
          result = ExtendedVigenere.instance.encrypt(Transposition.instance.encrypt(message, key_arr[1])[:result], key_arr[0])
        else
          result = Transposition.instance.decrypt(ExtendedVigenere.instance.decrypt(message, key_arr[0])[:result], key_arr[1])

          # remove tailing unprintable characters if input is text
          if input_type == "textInput"
            result[:result] = result[:result].tr('^ -~', '')
            result[:result_base64] = Base64.encode64(result[:result])
          end
        end
      end
    end

    # if input type is file, make the result as file with the same extension
    if input_type == "fileInput"
      original_file_name = File.basename(params[:file].original_filename, ".*")
      file_extension = File.extname(params[:file].original_filename)

      if act == "encrypt"
        file_name = "#{original_file_name}-encrypted-#{cipher}#{file_extension}"
      else
        file_name = "#{original_file_name}-decrypted-#{cipher}#{file_extension}"
      end
      file_path = Rails.root.join('tmp', file_name)

      # create a file with the result
      if is_cipher_256
        File.open(file_path, "wb") { |f| f.write(result[:result]) }
      else
        File.open(file_path, "w") { |f| f.write(result[:result]) }
      end

      # create a link to download the file
      result[:result] = "File #{file_name} has been created. Please download the file by clicking the button below."
      result[:result_base64] = "Base64 is not shown."
    else
      if result[:result].match?(/[^[:print:]]/) # message is text
        result[:result] = "Result contains non-printable characters."
      end

      # create a txt file with the result
      file_path = Rails.root.join('tmp', file_name)
      File.open(file_path, "w") do |f|
        f << "Unicode:\n"
        f << result[:result]
        f << "\n\nBase64:\n"
        f << result[:result_base64]
      end

      
    end

    result[:file_name] = file_name
    
    render json: result
    return
  end
end
