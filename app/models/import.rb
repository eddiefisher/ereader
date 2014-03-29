class Import < ActiveRecord::Base
  belongs_to :user
  mount_uploader :name, FileUploader
end
