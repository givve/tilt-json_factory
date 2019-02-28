# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tilt::JsonFactoryTemplate do
  let(:templates_path) { File.join(FIXTURE_PATH, 'templates') }

  describe 'rendering' do
    let(:template) { Tilt.new(template_path) }

    context 'of a simple template without locals' do
      let(:template_path) { File.join(templates_path, 'hello_world.jfactory') }

      it 'works' do
        expect(template.render).to eq('Hello World'.to_json)
      end
    end

    context 'of a simple template with locals' do
      let(:template_path) { File.join(templates_path, 'simple_locals.jfactory') }
      let(:locals) do
        { foo: 'foo', 
          bar: 'bar' }
      end

      it 'works' do
        expect(template.render(nil, locals)).to eq(locals.to_json)
      end
    end

    context 'of a simple template with an execution context' do
      let(:template_path) { File.join(templates_path, 'simple_scope.jfactory') }
      let(:scope) do
        instance = Object.new
        instance.instance_variable_set(:@hello_world, 'Hello World')
        instance
      end

      it 'works' do
        expect(template.render(scope)).to eq('Hello World'.to_json)
      end
    end
  end
end
