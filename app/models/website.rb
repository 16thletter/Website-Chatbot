class Website < ApplicationRecord
  has_many :page_chunks
  after_create_commit :generate_embedding

  def generate_embedding
    scraper = WebScraper.new(url)
    content = scraper.extract_text
    vector = OllamaEmbeddingService.embed(content)
    page_chunks.create!(embedding: vector, content:)
  rescue => e
    Rails.logger.error("Embedding generation failed: #{e.message}")
  end
end
