
# This class was automatically generated from XRC source. It is not
# recommended that this file is edited directly; instead, inherit from
# this class and extend its behaviour there.  
#
# Source file: sasquatch_window.xrc 
# Generated at: Sun Dec 06 04:40:17 -0500 2009

class MainFrame < Wx::Frame
	
	attr_reader :lb_haml_folder, :txt_haml, :br_haml, :lb_html_folder,
              :txt_html, :br_html, :lb_sass_folder, :txt_sass,
              :br_sass, :lb_css_folder, :txt_css, :br_css, :btn_watch,
              :lb_about_sasquatch, :lb_about_haml, :lb_ham_referencel,
              :lb_status, :text_status
	
	def initialize(parent = nil)
		super()
		xml = Wx::XmlResource.get
		xml.flags = 2 # Wx::XRC_NO_SUBCLASSING
		xml.init_all_handlers
		xml.load("sasquatch_window.xrc")
		xml.load_frame_subclass(self, parent, "main_frame")

		finder = lambda do | x | 
			int_id = Wx::xrcid(x)
			begin
				Wx::Window.find_window_by_id(int_id, self) || int_id
			# Temporary hack to work around regression in 1.9.2; remove
			# begin/rescue clause in later versions
			rescue RuntimeError
				int_id
			end
		end
		
		@lb_haml_folder = finder.call("lb_haml_folder")
		@txt_haml = finder.call("txt_haml")
		@br_haml = finder.call("br_haml")
		@lb_html_folder = finder.call("lb_html_folder")
		@txt_html = finder.call("txt_html")
		@br_html = finder.call("br_html")
		@lb_sass_folder = finder.call("lb_sass_folder")
		@txt_sass = finder.call("txt_sass")
		@br_sass = finder.call("br_sass")
		@lb_css_folder = finder.call("lb_css_folder")
		@txt_css = finder.call("txt_css")
		@br_css = finder.call("br_css")
		@btn_watch = finder.call("btn_watch")
		@lb_about_sasquatch = finder.call("lb_about_sasquatch")
		@lb_about_haml = finder.call("lb_about_haml")
		@lb_ham_referencel = finder.call("lb_ham_referencel")
		@lb_status = finder.call("lb_status")
		@text_status = finder.call("text_status")
		if self.class.method_defined? "on_init"
			self.on_init()
		end
	end
end


