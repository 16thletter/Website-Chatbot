class AddDocumentsToPageChunks < ActiveRecord::Migration[8.0]
  def change
    add_reference :page_chunks, :document, foreign_key: true, null: true
  end
end
