# encoding: utf-8


require 'pathname'
require './plugins/octopress_filters'
require 'erb'

module Jekyll

  class AdTag < Liquid::Tag
    include OctopressFilters
    def initialize(tag_name, name, tokens)
      @name = name
      super
    end

    def render(context)
      if template_file = (context.registers[:site].config['advertisement']||{})[:"#{@name.strip!}"]
        file_dir = (context.registers[:site].source || 'source')
        file_path = Pathname.new(file_dir).expand_path
        file = file_path + template_file
        unless file.file?
          return "File #{file} could not be found"
        end

        Dir.chdir(file_path) do
          erb = ERB.new(file.read)
          return erb.result(binding)
        end
      else
        raise "advertisement #{@name} is not found."
      end
    end
  end
end

Liquid::Template.register_tag('ad', Jekyll::AdTag)

