class WebsitesController < ApplicationController
  def analyze
    website = Website.create!(url: params[:url], last_viewed_at: Time.current)
    redirect_to chatbot_path(website)
  end

  def show; end
end
