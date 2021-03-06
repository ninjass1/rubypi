require 'gtk3'

require_relative 'building_layout_widget.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'poco_stats_widget.rb'
require_relative 'up_to_pi_config_button.rb'

require_relative '../common/planet_import_list.rb'
require_relative '../common/planet_export_list.rb'

require_relative '../gtk_helpers/clear_sort_button.rb'

# This is a layout-only widget that contains other, planet-specific widgets.
class PlanetView < Gtk::Box
  def initialize(controller)
	# Set up base GTK+ requirements.
	super(:vertical)
	
	# Store the controller whose actions this view can use.
	@controller = controller
	
	# Description and up button row widgets.
	description_label = Gtk::Label.new("Planet View")
	up_button = UpToPIConfigButton.new(@controller)
	
	# Pack the description and up button row widgets.
	description_and_up_button_row = Gtk::Box.new(:horizontal)
	description_and_up_button_row.pack_start(description_label, :expand => true)
	description_and_up_button_row.pack_start(up_button, :expand => false)
	self.pack_start(description_and_up_button_row, :expand => false)
	
	
	# Create the Bottom Row
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Left column(s)
	@building_layout_widget = BuildingLayoutWidget.new(@controller)
	bottom_row.pack_start(@building_layout_widget, :expand => true)
	
	# Right Column
	@planet_stats_widget = PlanetStatsWidget.new(@controller)
	planet_stats_widget_frame = Gtk::Frame.new
	planet_stats_widget_frame.add(@planet_stats_widget)
	
	@poco_stats_widget = PocoStatsWidget.new(@controller)
	
	
	@planet_import_list = PlanetImportList.new(@planet_model)
	planet_import_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_import_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_import_list_scrolled_window.add(@planet_import_list)
	
	planet_import_frame = Gtk::Frame.new
	planet_import_vbox = Gtk::Box.new(:vertical)
	planet_import_vbox.pack_start(Gtk::Label.new("Products Used / Hour"), :expand => false)
	planet_import_vbox.pack_start(planet_import_list_scrolled_window, :expand => true)
	planet_import_frame.add(planet_import_vbox)
	
	@planet_export_list = PlanetExportList.new(@planet_model)
	planet_export_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_export_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_export_list_scrolled_window.add(@planet_export_list)
	
	planet_export_frame = Gtk::Frame.new
	planet_export_vbox = Gtk::Box.new(:vertical)
	planet_export_vbox.pack_start(Gtk::Label.new("Products Created / Hour"), :expand => false)
	planet_export_vbox.pack_start(planet_export_list_scrolled_window, :expand => true)
	planet_export_frame.add(planet_export_vbox)
	
	right_column_vbox = Gtk::Box.new(:vertical)
	right_column_vbox.pack_start(planet_stats_widget_frame, :expand => false)
	right_column_vbox.pack_start(@poco_stats_widget, :expand => false)
	right_column_vbox.pack_start(planet_import_frame, :expand => true)
	right_column_vbox.pack_start(planet_export_frame, :expand => true)
	
	
	bottom_row.pack_start(right_column_vbox, :expand => false)
	
	
	# Add the "edit_planet_table" to the bottom portion of self's box.
	self.pack_start(bottom_row, :expand => true)
	
	# Show everything.
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Pass new @planet_model along to children.
	@building_layout_widget.planet_model = (@planet_model)
	@planet_stats_widget.planet_model = (@planet_model)
	@poco_stats_widget.planet_model = (@planet_model)
	@planet_import_list.planet_model = (@planet_model)
	@planet_export_list.planet_model = (@planet_model)
  end
end