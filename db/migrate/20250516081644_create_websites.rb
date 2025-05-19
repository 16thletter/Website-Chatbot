class CreateWebsites < ActiveRecord::Migration[8.0]
  def change
    create_table :websites do |t|
      t.string :url
      t.datetime :last_viewed_at

      t.timestamps
    end
  end
end
