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
        @html_folder = edit_line('<haml_folder>/output', :margin_right => 10)
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
        @css_folder = edit_line('<sass_folder>/stylesheets', :margin_right => 10)
        button("Browse", :align => 'right') do
          @css_folder.text= ask_open_folder
        end
      end
      flow do
        @start_button = button "Start\nWatching", :align => 'center', :width => 150, :height => 100, :margin => [50, 10, 10, 10] do
          start_watching
        end
        @stop_button = button "Not Watching", :align => 'center', :width => 100, :height => 100, :margin => [0, 10, 10, 10] do
          stop_watching
        end
      end

      para 'Status:', :points => 10, :weight => 'bold'
      @output = stack :height => 150, :scroll => true do
        background aliceblue
        code 'Not handling'
      end
    end
  end
  def retrieve_previous_settings
    puts puts File.exist?(File.expand_path(File.dirname(__FILE__) + '/config.ini'))
    settings_text =  IO.read(File.expand_path(File.dirname(__FILE__) + '/config.ini')) if File.exist('config.ini')
    parsed_settings = YAML::Load(settings_text)
    @haml_folder.text = parsed_settings[:haml_folder]
    @html_folder.text = parsed_settings[:html_folder]
    @sass_folder.text = parsed_settings[:sass_folder]
    @css_folder.text  = parsed_settings[:css_folder]
  end
  def save_settings
    File.open(File.expand_path(File.dirname(__FILE__) + '/config.ini'), 'w') do |f| 
      f.write YAML::dump({:haml_folder => @haml_folder, 
        :html_folder => @html_folder,
        :sass_folder => @sass_folder,
        :css_folder  => @css_folder})
    end
  end

  def start_watching
    @start_button.state = 'disabled'
    @stop_button.state = 'enabled'
    @thread = Thread.new do 
      @watcher = Watcher.new(@haml_folder.text, @sass_folder.text, @html_folder.text, @css_folder.text)
      @watcher.start do |output|
        #@output.append {code output}
      end
    end
    #@thread.join
    #save_settings
  end

  def stop_watching
    @start_button.state = 'enabled'
    @stop_button.state = 'disabled'
    @thread.kill! if @thread
  end
end


