 
require "rubygems"
require File.expand_path(File.dirname(__FILE__) +'/detector')
require File.expand_path(File.dirname(__FILE__) +'/transformer')

class Watcher
  extend Detector
  extend Transformer
  attr_accessor :haml_folder, :sass_folder, :html_folder, :css_folder

  def initialize(haml_folder = nil, sass_folder = nil, html_folder = nil, css_folder = nil, *args)
    @haml_folder = haml_folder
    @sass_folder = sass_folder
    @html_folder = html_folder
    @css_folder  = css_folder

  end

  add_detector('haml')
  add_detector('sass')

  add_transformer_for('haml', 'html') do |input_file, options|
     input = File.open(input_file, 'r')
     template = input.read()
     begin
       engine = ::Haml::Engine.new(template)
       result = engine.to_html
     rescue Exception => e

       case e
       when ::Haml::SyntaxError; puts "Syntax error on line #{get_line e}: #{e.message}"
       when ::Haml::Error;       puts "Haml error on line #{get_line e}: #{e.message}"
       else puts "Exception on line #{get_line e}: #{e.message}\n "
       end
     end
     result
  end

  add_transformer_for('sass', 'css') do |input_file, options|
     input = File.open(input_file, 'r')
     template = input.read()
     begin
       engine = ::Sass::Engine.new(template)
       result = engine.to_css
     rescue Exception => e

       case e
       when ::Sass::SyntaxError; puts "Syntax error on line #{get_line e}: #{e.message}"
       when ::Sass::Error;       puts "Sass error on line #{get_line e}: #{e.message}"
       else puts "Exception on line #{get_line e}: #{e.message}\n "
       end
     end
     result
  end

  def start
    @supposed_to_be_watching = true
    while  @supposed_to_be_watching
      if @haml_folder 
        haml_changes = haml_changes_in(@haml_folder)
        yield(transform_haml(haml_changes, @html_folder, @haml_folder)) unless haml_changes.empty?
      end

      if @sass_folder
        sass_changes = sass_changes_in(@sass_folder)
        yield(transform_sass(sass_changes, @css_folder, @sass_folder)) unless sass_changes.empty?
      end
      sleep 1
    end
    true
  end

  def stop
    @supposed_to_be_watching = false
  end
end
