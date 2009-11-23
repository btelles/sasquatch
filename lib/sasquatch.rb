require 'rubygems'
require 'ftools'
require 'haml'
require 'yaml'
require 'haml/engine'
require 'sass'
require 'sass/engine'
require 'hpricot'
require 'watcher'
require 'pty'

module Sasquatch
  def draw_main_window
    stack do
      @form
      flow do
        para "HAML Folder:", :margin_right => 10
        @haml_folder = edit_line :margin_right => 10
        button "Browse" do
          @haml_folder.text= ask_open_folder
        end
      end
      flow do
        para "HTML Output:", :margin_right => 12
        @html_folder = edit_line('', :margin_right => 10)
        button "Browse" do
          @html_folder.text= ask_open_folder
        end
      end
      flow do
        para "SASS Folder:", :margin_right => 10
        @sass_folder = edit_line :margin_right => 10
        button "Browse" do
          @sass_folder.text= ask_open_folder
        end
      end
      flow do
        para "CSS Output:", :margin_right => 20
        @css_folder = edit_line('', :margin_right => 10)
        button("Browse", :align => 'right') do
          @css_folder.text= ask_open_folder
        end
      end
      flow do
        @start_button = button "   Start\nWatching", :align => 'center', :width => 110, :height => 100, :margin => [10, 10, 10, 10] do
          start_watching
        end
        @stop_button = button "   Stop\nWatching", :align => 'center', :width => 100, :height => 100, :margin => [0, 10, 10, 10] do
          stop_watching
        end
        para link('HAML Website', :click => 'http://haml-lang.com/'), :top => 150, :left => 210
        para link('HAML Reference', :click => 'http://haml-lang.com/docs/yardoc/HAML_REFERENCE.md.html'), :top => 175, :left => 210
        para link('Sasquatch site', :click => 'http://github.com/btelles/sasquatch'), :top => 200, :left => 210
      end
      para 'Status:', :points => 10, :weight => 'bold'
      @output = stack :height => 150, :scroll => true do
        background aliceblue
        para'Not Watching'
      end
    end
  end
  def retrieve_previous_settings
    if File.exist?(File.dirname(__FILE__) + '/config.ini')
      settings_text =  IO.read(File.expand_path(File.dirname(__FILE__) + '/config.ini'))
      parsed_settings = YAML::load(settings_text)
    end
    @haml_folder.text = parsed_settings[:haml_folder]
    @html_folder.text = parsed_settings[:html_folder]
    @sass_folder.text = parsed_settings[:sass_folder]
    @css_folder.text  = parsed_settings[:css_folder]
  end
  def save_settings
    File.open(File.expand_path(File.dirname(__FILE__) + '/config.ini'), 'w') do |f| 
      f.write YAML::dump({:haml_folder => @haml_folder.text, 
        :html_folder => @html_folder.text,
        :sass_folder => @sass_folder.text,
        :css_folder  => @css_folder.text})
    end
  end

  def start_watching
    @start_button.hide
    @stop_button.show
    @output.append {para "Started Watching..."}
    @thread = Thread.new do 
      @watcher = Watcher.new(@haml_folder.text, @sass_folder.text, @html_folder.text, @css_folder.text)
      @watcher.start do |output|
        @output.append {para output}
      end
    end
    save_settings
  end

  def stop_watching
    @start_button.show
    @stop_button.hide
    @thread.kill! if @thread
    @output.append {para "Stopped Watching."}
  end
end


