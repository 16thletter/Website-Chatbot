class Website < ApplicationRecord
  has_many :page_chunks
  has_many :questions

  after_create_commit :generate_embedding

  def generate_embedding
    GenerateEmbeddingsJob.perform_later(id)
  end

  def generate_context(question)
    question_embedding = normalise(OllamaEmbeddingService.embed(question))

    results = PageChunk.nearest_neighbors(:embedding, question_embedding, distance: "euclidean").first(5)

    results.map do |pc|
      "Page #{pc.page} – #{pc.heading}\n#{pc.content}"
    end.join("\n---\n")[0..2000]
  end

  private

  def normalise(vec)
    norm = Math.sqrt(vec.map { |x| x * x }.sum)
    norm.zero? ? vec : vec.map { |x| x / norm }
  end
end
