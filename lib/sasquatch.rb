require 'rubygems'
require 'ftools'
require 'haml'
require 'haml/engine'
require 'sass'
require 'sass/engine'
require 'hpricot'
require 'sasquatch/watcher'

module Sasquatch
  def draw_main_window
    stack do
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
        @haml_folder = edit_line :margin_right => 10
        button "Browse" do
          @haml_folder.text= ask_open_folder
        end
      end
      flow do
        para "CSS Output:", :margin_right => 20
        @css_folder = edit_line('<sass_folder>/stylesheets', :margin_right => 10)
        button("Browse", :align => 'right') do
          @css_folder.text= ask_open_folder
        end
      end
      button "Handle\n   my\n HAML", :align => 'center', :width => 270, :height => 100, :margin => [150, 10, 10, 10]
      para 'Status:', :points => 10, :weight => 'bold'
      stack :height => 150, :scroll => true do
        background aliceblue
        @output = para 'Not handling'
      end
    end
  end
end


