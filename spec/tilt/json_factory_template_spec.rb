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

    context 'of a template including a partial' do
      let(:template_path) { File.join(templates_path, 'includes_partial.jfactory') }
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

    xcontext 'of a template including a partial with an execution context' do
      let(:template_path) { File.join(templates_path, 'includes_partial_with_scope.jfactory') }
      let(:locals) do
        { foo: 'foo',
          bar: 'bar' }
      end
      let(:scope) do
        instance = Object.new
        instance.instance_variable_set(:@hello_world, 'Hello World')
        instance
      end

      it 'works' do
        expect(template.render(scope, locals)).to eq(locals.merge(hello_world: 'Hello World').to_json)
      end
    end

    context 'with content yielding' do
      let(:template_path) { File.join(templates_path, 'with_yield.jfactory') }

      it 'works' do
        output = template.render do
          'Hello World'
        end

        expect(output).to eq('Hello World'.to_json)
      end
    end

    context 'with json tag' do
      let(:template_path) { File.join(templates_path, 'with_json.jfactory') }
      let(:json) { 'Hello World'.to_json }

      it 'works' do
        expect(template.render(nil, fragment: json)).to eq(json)
      end
    end
  end
end
