# frozen_string_literal: true
require 'tilt'
require 'json_factory'

require_relative 'json_factory/version'
require_relative 'json_factory_template'

module Tilt
  module JSONFactory
    class TypeNotAllowedError < ::JSONFactory::TypeNotAllowedError; end

    class DSL < ::JSONFactory::DSL
      def json(value)
        @builder.json(value)
      end
    end

    class JSONBuilder < ::JSONFactory::JSONBuilder
      EMBEDABLE_VARIABLE_NAME = '__content__'

      def json(value)
        io << value
        increment_count
      end

      def evaluate(template_string, scope, local_variables, filename, linenumber, &block)
        context = build_execution_context(scope, local_variables, &block)
        eval(template_string, context, filename, linenumber) # rubocop:disable Security/Eval
      end

      def build_execution_context(scope, locals, &block)
        dsl = DSL.new(self)
        binding = jfactory(scope, dsl) 
        locals.each_pair do |key, value|
          binding.local_variable_set(key, value)
        end
        binding.local_variable_set(BUILDER_VARIABLE_NAME, dsl)
        # HACK: allows the use of layouts. However since layouts usually call
        #       yield to embed the actual view content, we'd have to monkey
        #       patch each and every dsl method to receive an optional embeddable
        #       block.
        #       This allows us to just change one place to set the content to
        #       be embedded for templates that are used as layouts.
        binding.local_variable_set(EMBEDABLE_VARIABLE_NAME, block.call) if block
        binding
      end
    end
  end
end
    
Tilt::JSONFactory::JSONBuilder.class_eval do
  # Returns an empty evaluation context, similar to Ruby's main object.
  def jfactory(scope, __dsl__)
    (scope || Object.allocate).instance_eval do
      class << self
        JSONFactory.configure.helpers.each { |mod| include mod }

        def to_s
          'jfactory'
        end
        alias inspect to_s
      end

      define_singleton_method(:__dsl__) do
        __dsl__
      end

      def method_missing(method_name, *args, &block)
        if __dsl__.respond_to?(method_name)
          __dsl__.send(method_name, *args, &block)
        else
          super
        end
      end
      
      return binding
    end
  end
  private :jfactory
end
