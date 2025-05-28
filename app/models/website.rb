class Website < ApplicationRecord
  has_many :page_chunks
  has_many :questions

  after_create_commit :generate_embedding

  def generate_embedding
    GenerateEmbeddingsJob.perform_later(id)
  end

  def generate_context(question)
    question_embedding = OllamaEmbeddingService.embed(question)

    results = page_chunks.nearest_neighbors(:embedding, question_embedding, distance: "euclidean").first(10)

    results.map do |pc|
      "Page #{pc.page} – #{pc.heading}\n#{pc.content}"
    end.join("\n---\n")[0..2000]
  end
end
