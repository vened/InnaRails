class Location
  include Mongoid::Document
  field :name, type: String
  field :slug, type: String
  embedded_in :page

end