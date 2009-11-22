require File.dirname(__FILE__) + '/../spec_helper'

describe "Watcher" do
  require 'ruby-debug'
  it 'should assign folders on initialization' do
    w = Watcher.new('ham', 'sa', 'htm', 'cs')
    w.haml_folder.should == 'ham'
    w.sass_folder.should == 'sa'
    w.html_folder.should == 'htm'
    w.css_folder.should == 'cs'
  end

  describe "watch" do
    describe 'haml actions' do
      before :all do
        @fixtures = File.expand_path(File.dirname(__FILE__)+ '/../fixtures')
        @watcher = Watcher.new('haml_folder', 'sass_folder', 'html_folder', 'css_folder')
      end
      it 'should know when a haml file has changed' do
        #File.should_receive(:join).with('haml_folder', '**', '*.haml')
        Dir.should_receive(:glob).with('haml_folder/**/*.haml').and_return(['a.haml'])
        File.should_receive(:mtime).with('a.haml').and_return(Time.now)

        @watcher.haml_changes_in('haml_folder').should include('a.haml')
      end
      it 'transform_haml should create the output folder if it does not exist, and convert the haml file.' do
         File.should_receive('directory?').with('html_folder/new').and_return(false)
         FileUtils.should_receive(:makedirs).with('html_folder/new')
         File.should_receive(:open).with('haml_folder/new/a.haml', 'r').and_return(mock(File, :read => "%h1 Hello World", :close => true))
         File.should_receive(:open).with('html_folder/new/a.html', 'w').and_return(mock(File, :write => 'aoeu', :close => true))
         
         @watcher.transform_haml(['haml_folder/new/a.haml'], @watcher.html_folder, @watcher.haml_folder)
      end
      it 'should log when it converts a haml file' do
        File.should_receive('directory?').with('html_folder/new').and_return(false)
        FileUtils.should_receive(:makedirs).with('html_folder/new')
        File.should_receive(:open).with('haml_folder/new/a.haml', 'r').and_return(mock(File, :read => "%h1 Hello World", :close => true))
        File.should_receive(:open).with('html_folder/new/a.html', 'w').and_return(mock(File, :write => 'aoeu', :close => true))
        @watcher.should_receive(:puts).with('Regenerated haml_folder/new/a.haml')
        @watcher.transform_haml(['haml_folder/new/a.haml'], @watcher.html_folder, @watcher.haml_folder)
      end
    end 

    describe 'sass actions' do
      before :all do
        @fixtures = File.expand_path(File.dirname(__FILE__)+ '/../fixtures')
        @watcher = Watcher.new('haml_folder', 'sass_folder', 'html_folder', 'css_folder')
      end
      it 'should know when a sass file has changed' do
        Dir.should_receive(:glob).with('sass_folder/**/*.sass').and_return(['a.sass'])
        File.should_receive(:mtime).with('a.sass').and_return(Time.now)

        @watcher.sass_changes_in('sass_folder').should include('a.sass')
      end
      it 'transform_sass should create the output folder if it does not exist, and convert the sass file.' do
         File.should_receive('directory?').with('css_folder/new').and_return(false)
         FileUtils.should_receive(:makedirs).with('css_folder/new')
         File.should_receive(:open).with('sass_folder/new/a.sass', 'r').and_return(mock(File, :read => "%h1 Hello World", :close => true))
         File.should_receive(:open).with('css_folder/new/a.css', 'w').and_return(mock(File, :write => 'aoeu', :close => true))

         @watcher.transform_sass(['sass_folder/new/a.sass'], @watcher.css_folder, @watcher.sass_folder)
      end
      it 'should log when it converts a sass file' do
        File.should_receive('directory?').with('css_folder/new').and_return(false)
        FileUtils.should_receive(:makedirs).with('css_folder/new')
        File.should_receive(:open).with('sass_folder/new/a.sass', 'r').and_return(mock(File, :read => "h1\n  color: #fff", :close => true))
        File.should_receive(:open).with('css_folder/new/a.css', 'w').and_return(mock(File, :write => 'aoeu', :close => true))

        @watcher.should_receive(:puts).with('Regenerated sass_folder/new/a.sass')
        @watcher.transform_sass(['sass_folder/new/a.sass'], @watcher.css_folder, @watcher.sass_folder)
      end
    end

    describe 'start_watching' do
      before :all do
        @watcher = Watcher.new('haml_folder', 'sass_folder', 'html_folder', 'css_folder')
      end
      it 'should begin an endless loop, until we tell it to stop' do
        @watcher.start
        @watcher.stop
      end
    end
  end
end
