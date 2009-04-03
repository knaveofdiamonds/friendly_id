# AttributeAsUriId
module Knave
  module FriendlyId
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      # Allows you to use an attribute as the id in Model#find(id) calls
      # (in addition to the numeric id).
      # 
      # Generates appropriate to_param method and validations to ensure
      # presence and uniqueness.
      def friendly_id(attribute)
        cattr_accessor :friendly_id_attribute
        self.friendly_id_attribute = attribute
        validates_uniqueness_of attribute
        validates_presence_of attribute

        class << self
          alias_method :find_without_friendly_id, :find

          def find(*args)
            if args.first =~ /\D/
              options = args.last.kind_of?(Hash) ? args.last : {}
              with_scope( :find => { 
                            :conditions => {
                              friendly_id_attribute => CGI.unescape(args.first) }} ) do
                find_without_friendly_id(:first, options) or raise ActiveRecord::RecordNotFound
              end
            else
              find_without_friendly_id(*args)
            end
          end
        end

        include InstanceMethods
      end
    end

    module InstanceMethods # :nodoc:
      def to_param
        CGI.escape(send(self.class.friendly_id_attribute).strip).gsub(".", "%2e")
      end
    end
  end
end
