class Offer
  include Mongoid::Document

  field :StartVoyageDate, type: DateTime
  field :EndVoyageDate, type: DateTime
  field :Price, type: Float
  field :SearchUrl, type: String
  field :SearchDate, type: String

  field :Hotel, type: Object
  field :Rooms, type: Object
  field :AviaInfo, type: Object

  embedded_in :departure

end