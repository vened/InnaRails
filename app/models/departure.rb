class Departure
  include Mongoid::Document
  field :name, type: String, default: ''
  field :RawName, type: String, default: ''
  field :DepartureId, type: String, default: 6733
  field :slug, type: String
  field :tours, type: Array
  field :isDefault, type: Boolean, default: false
  embedded_in :page

  rails_admin do
    edit do
      field :name
      field :DepartureId
      field :isDefault
    end
  end

end