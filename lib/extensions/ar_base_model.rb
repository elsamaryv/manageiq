module ActiveRecord
  class Base
    class << self
      alias_method :base_model, :base_class

      def base_model?
        base_model == self
      end

      def model_suffix
        name[base_model.name.length..-1]
      end
    end
  end
end
