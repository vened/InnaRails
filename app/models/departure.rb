class Departure
  include Mongoid::Document
  field :name, type: String
  field :DepartureId, type: String
  field :slug, type: String
  field :tours, type: Array
  embedded_in :page

end