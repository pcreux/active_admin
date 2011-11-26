module ActiveAdmin
  class Resource < Config
    module Naming
      # Returns the name to call this resource such as "Bank Account"
      def resource_name
        @resource_name ||= @options[:as]
        @resource_name ||= singular_human_name
        @resource_name ||= resource.name.gsub('::',' ')
      end

      # Returns the plural version of this resource such as "Bank Accounts"
      def plural_resource_name
        @plural_resource_name ||= @options[:as].pluralize if @options[:as]
        @plural_resource_name ||= plural_human_name
        @plural_resource_name ||= resource_name.pluralize
      end

      def internal_resource_name
        @internal_resource_name ||= if @options[:as]
          @options[:as].gsub(' ', '').underscore.singularize
        else
          resource.name.gsub('::','').underscore
        end
      end


      private

      # @return [String] Titleized human name via ActiveRecord I18n or nil
      def singular_human_name
        return nil unless resource.respond_to?(:model_name)
        resource.model_name.human.titleize
      end

      # @return [String] Titleized plural human name via ActiveRecord I18n or nil
      def plural_human_name
        return nil unless resource.respond_to?(:model_name)

        begin
          I18n.translate!("activerecord.models.#{resource.model_name.underscore}.other").titleize
        rescue I18n::MissingTranslationData
          nil
        end
      end
    end
  end
end
