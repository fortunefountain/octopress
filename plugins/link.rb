# encoding: utf-8
# Title: Render Partial Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Import files on your filesystem into any blog post and render them inline.
# Note: Paths are relative to the source directory, if you import a file with yaml front matter, the yaml will be stripped out.
#
# Syntax {% render_partial path/to/file %}
#
# Example 1:
# {% render_partial about/_bio.markdown %}
#
# This will import source/about/_bio.markdown and render it inline.
# In this example I used an underscore at the beginning of the filename to prevent Jekyll
# from generating an about/bio.html (Jekyll doesn't convert files beginning with underscores)
#
# Example 2:
# {% render_partial ../README.markdown %}
#
# You can use relative pathnames, to include files outside of the source directory.
# This might be useful if you want to have a page for a project's README without having
# to duplicated the contents
#
#

require 'pathname'
require './plugins/octopress_filters'

module Jekyll

  class LinkUrlTag < Liquid::Tag
    include OctopressFilters
    def initialize(tag_name, name, tokens)
      @name = name
      super
    end

    def render(context)
      if url = context.registers[:site].config['link'][:"#{@name.strip!}"]
        "<a href=\"#{url}\">#{@name.sub(/(_\d+)$/,"")}</a>"
      else
        puts "link #{@name} is not found."
        @name
      end
    end
  end
end

Liquid::Template.register_tag('link', Jekyll::LinkUrlTag)

