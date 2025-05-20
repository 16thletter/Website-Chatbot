class Website < ApplicationRecord
  has_many :page_chunks
  after_create_commit :generate_embedding

  def generate_embedding
    GenerateEmbeddingsJob.perform_later(id)
  end
end
