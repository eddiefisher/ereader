class Channel < ActiveRecord::Base
  has_many :entries
end
