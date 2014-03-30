class FixVarcharLength < ActiveRecord::Migration
  def change
    change_column :entries, :url, :string, :limit => 1000
    change_column :entries, :guid, :string, :limit => 1000
  end
end
