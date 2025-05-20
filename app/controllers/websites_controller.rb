class WebsitesController < ApplicationController
  def analyze
    scraper = WebScraper.new(params[:url])
    content = scraper.extract_text
    website = Website.create!(url: params[:url], last_viewed_at: Time.current, content:)
    redirect_to chatbot_path(website)
  end
end
