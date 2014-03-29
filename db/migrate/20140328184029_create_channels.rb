class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string   :name,       null: false, default: ""
      t.string   :url,        null: false, default: ""
      t.string   :color,      null: false, default: ""
      t.boolean  :locked,     default: false
      t.datetime :locked_at

      t.timestamps
    end
  end
end
