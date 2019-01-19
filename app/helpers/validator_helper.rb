module ValidatorHelper

  def validate zip_file
    is_valid = true
    status_string is_valid
  end

  def status_string is_valid
    if is_valid
      "Congratulations! It's a valid Eclipse export!"
    else
      "Sorry, that's not a valid Eclipse export. Feel free to try again!"
    end
  end

end
