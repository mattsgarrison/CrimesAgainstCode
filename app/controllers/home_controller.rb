require 'rqrcode'

class HomeController < ApplicationController
  def index
  end

  def code
    layout = nil
    @qr = RQRCode::QRCode.new(params[:content])
    respond_to do |format|
      format.html{render :layout => false}
      format.json{render json: @qr}
    end
  end

end
