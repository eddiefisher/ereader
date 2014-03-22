class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.text :summary
      t.text :body
      t.string :url
      t.datetime :published_at
      t.string :guid

      t.timestamps
    end
  end
end
