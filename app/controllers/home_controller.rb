require 'rqrcode'

class HomeController < ApplicationController
  def index
  end

  def code
    @qr = RQRCode::QRCode.new(params[:content], :size => 4)
    respond_to do |format|
      format.html
      format.json{render json: @qr}
    end
  end

end
