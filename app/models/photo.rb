class Photo < ActiveRecord::Base
  # When writing to the :file column, mount_uploader is called instead
  mount_uploader :file, Uploader
  belongs_to :album
end
