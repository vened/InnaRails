class Departure
  include Mongoid::Document
  field :name, type: String, default: ''
  field :title, type: String, default: ''
  field :calendar_title, type: String, default: ''
  field :RawName, type: String, default: ''
  field :DepartureId, type: String, default: 6733
  field :slug, type: String
  field :tours, type: Array
  field :isDefault, type: Boolean, default: false
  embedded_in :page

  rails_admin do
    edit do
      field :name, :string do
        label 'Название города'
      end
      field :title, :string do
        label 'Заголовок страницы для этого города'
      end
      field :calendar_title, :string do
        label 'Заголовок календаря'
      end
      field :DepartureId, :string do
        label 'Системный ID города'
      end
      field :isDefault do
        label 'город отправления по умолчанию'
      end
    end
  end

end