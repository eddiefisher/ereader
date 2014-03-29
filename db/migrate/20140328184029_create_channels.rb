class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string   :text,       null: false, default: ""
      t.string   :title,      null: false, default: ""
      t.string   :feed_type,  null: false, default: ""
      t.string   :xml_url,    null: false, default: ""
      t.string   :html_url,   null: false, default: ""
      t.string   :color,      null: false, default: ""
      t.boolean  :locked,     default: false
      t.datetime :locked_at

      t.timestamps
    end
  end
end
