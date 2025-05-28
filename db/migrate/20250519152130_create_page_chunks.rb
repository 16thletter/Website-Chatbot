class CreatePageChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :page_chunks do |t|
      t.references :website, null: true, foreign_key: true
      t.text :content
      # t.column :embedding, :vector, limit: 384

      t.timestamps
    end
  end
end
