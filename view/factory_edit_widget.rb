
require 'gtk3'
# require_relative 'planet_image.rb'
# require_relative 'building_count_table.rb'
# require_relative '../model/planet.rb'
require_relative '../model/schematic.rb'

# This widget will show a planet, its buildings, and building-related stats.

class FactoryEditWidget < Gtk::Box
  def initialize(factory_model)
	super(:vertical)
	
	# Hook up model data.
	@factory_model = factory_model
	@factory_model.add_observer(self)
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	factory_stats_table = Gtk::Table.new(7, 2)
	
	# Planet Image Row
	#@planet_image = PlanetImage.new(@planet_model)
	# Stick it in the top row, across all columns.
	#factory_stats_table.attach(@planet_image, 0, 2, 0, 1)
	
	# Schematic Row
	schematic_label = Gtk::Label.new("Schematic:")
	
	# Populate the combobox backend model.
	@list_store_of_schematics = Gtk::ListStore.new(String)
	
	# Populate the list store with the schematics this factory can accept.
	@factory_model.accepted_schematics.each do |schematic|
	  new_row = @list_store_of_schematics.append
	  new_row.set_value(0, schematic.name)
	end
	
	@schematic_combo_box = Gtk::ComboBox.new(:model => @list_store_of_schematics)
	
	# Set up the view for the combo box column.
	combobox_renderer = Gtk::CellRendererText.new
	@schematic_combo_box.pack_start(combobox_renderer, true)
	@schematic_combo_box.add_attribute(combobox_renderer, "text", 0)
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	
	factory_stats_table.attach(schematic_label, 0, 1, 1, 2)
	factory_stats_table.attach(@schematic_combo_box, 1, 2, 1, 2)
	
	self.pack_start(factory_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  # Set the current value's row active.
	  @list_store_of_schematics.each do |model, path, iter|
		if (@factory_model.schematic != nil)
		  if (@factory_model.schematic.name == iter.get_value(0))
			@schematic_combo_box.active_iter=(iter)
		  end
		end
	  end
	  
	  # Other things as I add them.
	  #
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	@factory_model.delete_observer(self)
	
	# Ignore commit unless the user picked something legit.
	if (@schematic_combo_box.active_iter == nil)
	  return
	end
	
	@factory_model.accepted_schematics.each do |schematic|
	  if ((schematic.name) == (currently_selected_schematic_name))
		@factory_model.schematic = schematic
	  end
	end
	
	# Start observing again.
	@factory_model.add_observer(self)
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@factory_model.delete_observer(self)
	
	super
  end
  
  private
  
  def return_to_system_view
	$ruby_pi_main_gtk_window.change_main_widget(PlanetViewWidget.new(@planet_model.pi_configuration))
  end
end