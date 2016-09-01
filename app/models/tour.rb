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

  field :Details, type: Object


  embedded_in :departure


  rails_admin do
    edit do
      field :StartVoyageDate, :date do
        label 'Дата вылета'
      end
    end
  end



end