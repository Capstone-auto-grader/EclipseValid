include ValidatorHelper

class ValidatorController < ApplicationController

  def home
    @zip_status = validate params[:zip_file][:file] unless params[:zip_file].nil?
  end

end
