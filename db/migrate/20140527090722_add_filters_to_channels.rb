class AddFiltersToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :filters, :string, null: false, default: 'readabilityfilter', after: :color
  end
end
