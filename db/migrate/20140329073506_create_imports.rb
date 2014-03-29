class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
  end
end
