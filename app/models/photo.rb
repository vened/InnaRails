class Photo
  include Mongoid::Document
  field :image, type: String
  embedded_in :page, inverse_of: :photos
  mount_uploader :image, PhotoUploader
end