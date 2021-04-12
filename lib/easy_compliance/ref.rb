module EasyCompliance
  # allows identifying records after submission
  module Ref
    class Error < EasyCompliance::Error; end

    module_function

    # @return [ String ]
    def for_record(record)
      self.for(record_class: record.class.name, record_id: record.id)
    end

    # @return [ String ]
    def for(record_class:, record_id:)
      [app_name, record_class, record_id].join('#')
    end

    # Converts a previously created Ref string back into a record.
    #
    # @return [ ActiveRecord::Base | NilClass ]
    def look_up(ref)
      app_name, record_class, record_id = ref.split('#')
      app_name == self.app_name or raise Error, "Ref `#{ref}` is from wrong app"
      begin
        record_class.constantize.find_by(id: record_id)
      rescue NameError, NoMethodError => e
        raise Error, "Ref `#{ref}` not supported: #{e.message}"
      end
    end

    def app_name
      EasyCompliance.app_name or raise Error, 'must set app_name'
    end
  end
end
