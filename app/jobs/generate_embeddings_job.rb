class GenerateEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform(id)
    website = Website.find_by(id:)
    return unless website

    scraper = WebScraper.new(website.url, website_id: website.id)
    scraper.extract_and_save_chunks
  end
end
