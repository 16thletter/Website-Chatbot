class AddHeadingToPageChunks < ActiveRecord::Migration[8.0]
  def change
    add_column :page_chunks, :heading, :string
  end
end
