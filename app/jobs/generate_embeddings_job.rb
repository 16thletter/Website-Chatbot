class GenerateEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform(id)
    website = Website.find_by(id:)
    return unless website

    text = WebScraper.new(website.url).extract_text
    vector = OllamaEmbeddingService.embed(text).to_s
    website.page_chunks.create!(embedding: vector, content: text)
  end
end
