class AddEmbeddingsToPageChunks < ActiveRecord::Migration[8.0]
  def change
    add_column :page_chunks, :embedding, :vector, limit: 768
  end
end
