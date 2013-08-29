require 'gtk3'

require_relative '../common/planet_image.rb'
require_relative '../common/building_count_table.rb'

class PlanetListRow < Gtk::Box
  def initialize(controller, planet_model)
	super(:horizontal)
	
	@controller = controller
	@planet_model = nil
	
	planet_image_and_name_column = Gtk::Box.new(:vertical)
	@planet_image = PlanetImage.new(@planet_model)
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	planet_image_and_name_column.pack_start(@planet_image, :expand => false)
	planet_image_and_name_column.pack_start(@planet_name_label, :expand => false)
	
	@planet_buildings_box = BuildingCountTable.new(@planet_model)
	
	planet_import_list = Gtk::Label.new("Import List")
	planet_export_list = Gtk::Label.new("Export List")
	
	edit_delete_button_column = Gtk::Box.new(:vertical)
	edit_button = Gtk::Button.new(:label => "Edit")
	edit_button.image = Gtk::Image.new(:file => "view/images/16x16/edit-find-replace.png")
	edit_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.edit_selected_planet(@planet_model)
	  end
	end
	
	delete_button = Gtk::Button.new(:label => "Delete")
	delete_button.image = Gtk::Image.new(:file => "view/images/16x16/edit-find-replace.png")
	delete_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.remove_planet(@planet_model)
	  end
	end
	
	edit_delete_button_column.pack_start(edit_button, :expand => false)
	edit_delete_button_column.pack_start(delete_button, :expand => false)
	
	self.pack_start(planet_image_and_name_column, :expand => false)
	self.pack_start(@planet_buildings_box, :expand => false)
	self.pack_start(planet_import_list, :expand => true)
	self.pack_start(planet_export_list, :expand => true)
	self.pack_start(edit_delete_button_column, :expand => false)
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Update base widgets.
	@planet_name_label.text = "#{@planet_model.name}"
	
	# Push to complex children.
	@planet_image.planet_model = @planet_model
	@planet_buildings_box.planet_model = @planet_model
  end
end