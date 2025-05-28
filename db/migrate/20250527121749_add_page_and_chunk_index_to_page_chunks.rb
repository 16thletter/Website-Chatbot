class AddPageAndChunkIndexToPageChunks < ActiveRecord::Migration[8.0]
  def change
    add_column :page_chunks, :page, :integer
    add_column :page_chunks, :chunk_index, :integer
  end
end
