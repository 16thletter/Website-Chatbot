class Website < ApplicationRecord
  has_many :page_chunks
  after_create_commit :generate_embedding

  def generate_embedding
    GenerateEmbeddingsJob.perform_later(id)
  end

  def generate_context(question)
    question_embedding = OllamaEmbeddingService.embed(question)
    results = page_chunks.order(Arel.sql("embedding <-> '#{question_embedding.to_json}'"))

    results.map do |chunk|
      heading = chunk.try(:heading) || "Section"
      "#{heading}\n#{chunk.content.strip}"
    end.join("\n---\n")[0..2000]
  end
end
