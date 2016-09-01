class Tour
  include Mongoid::Document

  # поля модели
  field :StartVoyageDate, type: DateTime
  field :EndVoyageDate, type: DateTime
  field :Since, type: DateTime
  field :Till, type: DateTime

  field :Price, type: Float

  field :Adult, type: Integer
  field :TicketClass, type: Integer

  field :ChildAges, type: Array

  field :Host, type: String


  embedded_in :departure
end