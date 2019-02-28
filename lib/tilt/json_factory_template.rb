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
      ::JSONFactory.build(@data, locals)
    end
  end

  register Tilt::JsonFactoryTemplate, 'jfactory'
end
