class Departure
  include Mongoid::Document
  field :name, type: String, default: ''
  field :title, type: String, default: ''
  field :calendar_title, type: String, default: ''
  field :RawName, type: String, default: ''
  field :DepartureId, type: String, default: 6733
  field :slug, type: String
  field :tours, type: Array
  field :offers, type: Array
  field :isDefault, type: Boolean, default: false

  # field :offer_title, type: String
  # field :offer_photo, type: String

  embedded_in :page
  embeds_many :tours
  embeds_many :offers
  accepts_nested_attributes_for :tours, :allow_destroy => true

  mount_uploader :offer_photo, PhotoUploader
  #--
  # Валидации
  validates_presence_of :name, message: 'Название города не может быть пустым!'
  validates_uniqueness_of :name, message: 'Название города должно быть уникальным, введенное вами уже существует в системе!'
  validates_length_of :name, minimum: 1, maximum: 100, message: 'Название города не может быть короче 1 символа и длиннее 100!'

  validates_presence_of :title, message: 'Заголовок страницы не может быть пустым!'
  validates_uniqueness_of :title, message: 'Заголовок страницы должен быть уникальным, введенный вами уже существует в системе!'
  validates_length_of :title, minimum: 1, maximum: 100, message: 'Заголовок страницы не может быть короче 1 символа и длиннее 100!'

  validates_presence_of :DepartureId, message: 'Системный ID города не может быть пустым!'
  validates_uniqueness_of :DepartureId, message: 'Системный ID города должен быть уникальным, введенный вами уже существует в системе!'
  #++


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
      # field :tours do
      #   label 'Туры'
      # end
    end
  end

end