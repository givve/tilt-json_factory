# frozen_string_literal: true

module Tilt
  class JsonFactoryTemplate < Template
    self.metadata[:mime_type] = 'application/json'

    def default_encoding
      super || 'UTF-8'
    end

    def prepare
    end

    def render(scope=nil, locals={}, &block)
      buffer = StringIO.new
      builder = ::Tilt::JSONFactory::JSONBuilder.new(buffer)
      builder.evaluate(@data, scope, locals, @file, @line)
      buffer.string
    end
  end

  register Tilt::JsonFactoryTemplate, 'jfactory'
end
