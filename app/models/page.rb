class Page
  include Mongoid::Document
  field :title, type: String
  field :slogan, type: String


  rails_admin do
    list do
      field :title
    end
    edit do
      # For RailsAdmin >= 0.5.0
      field :title
      field :slogan, :ck_editor
      # For RailsAdmin < 0.5.0
      # field :description do
      #   ckeditor true
      # end
    end
  end
end
