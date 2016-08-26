require "simple_form"
require "rails_admin_multiple_upload/engine"

module RailsAdminMultipleUpload
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class MultipleUpload < Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-upload'
        end

        register_instance_option :http_methods do
          [:get, :post, :delete]
        end

        register_instance_option :controller do
          Proc.new do
            @response = {}

            if request.post?
              @object = @abstract_model.model.find(params[:id])
              @params = params[@abstract_model.param_key]

              if @params.present?
                @params[:second_attr].each do |image|
                  @object.photos.create(image: image)
                end

                flash[:success] = 'Фотографии успешно загружены'
              end
              render :action => @action.template_name
            end

            if request.delete?
              @object = @abstract_model.model.find(params[:id])
              @photo  = @object.photos.find(params[:image])
              @photo.destroy
              flash[:success] = 'Фотография успешно удалена'
              redirect_to "/admin/page/#{params[:id]}/multiple_upload"
            end

          end
        end
      end
    end
  end
end
