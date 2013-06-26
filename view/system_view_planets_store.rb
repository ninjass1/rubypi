require_relative '../model/planet.rb'

class SystemViewPlanetsStore < Gtk::ListStore
  
  # HACK
  # I should really change PlanetImage to not mandate a planet instance.
  
  TYPE_TO_FILENAME = {"Gas" => "gas_planet.png",
                      "Ice" => "ice_planet.png",
                      "Storm" => "storm_planet.png",
                      "Barren" => "barren_planet.png",
                      "Temperate" => "temperate_planet.png",
                      "Lava" => "lava_planet.png",
                      "Oceanic" => "oceanic_planet.png",
                      "Plasma" => "plasma_planet.png"}
  
  
  def initialize(pi_configuration_model)
	
	super(Integer,      # Index
		  Planet,       # Planet Instance
		  Gdk::Pixbuf,	# Icon
	      String,		# Name
	      String,		# Text form of Percent PG Usage
	      Integer,		# Percent of PG Usage progress bar to fill (as it can't take values > 100)
	      String,		# Text form of Percent CPU Usage
	      Integer,		# Percent of CPU Usage progress bar to fill (as it can't take values > 100)
	      Integer,		# Number of Extractors
	      Integer,		# Number of Factories
	      Integer,		# Number of Storages
	      Integer		# Number of Launchpads
	      )
	
	# Link to the model.
	@pi_configuration_model = pi_configuration_model
	
	# Populate self from model.
	self.update
	
	return self
  end
  
  def pi_configuration_model=(new_pi_configuration_model)
	self.stop_observing_model
	
	@pi_configuration_model = new_pi_configuration_model
	self.update
	
	self.start_observing_model
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  self.clear
	
	  @pi_configuration_model.planets.each_with_index do |planet, index|
		new_planet_row = self.append
		new_planet_row.set_value(0, index)
		new_planet_row.set_value(1, planet)
		new_planet_row.set_value(2, Gtk::Image.new(:file => calculate_planet_image_filename(planet.type)).pixbuf)
		new_planet_row.set_value(3, planet.name)
		
		# Value of text in progress bar. Round to 2 digits.
		new_planet_row.set_value(4, "#{planet.pct_powergrid_usage.round(2)} %")
		
		# Amount to fill progress bar. Must be an Int or GTK gets mad.
		if (planet.pct_powergrid_usage > 100)
		  new_planet_row.set_value(5, 100)
		else
		  new_planet_row.set_value(5, planet.pct_powergrid_usage.to_int)
		end
		
		# Value of text in progress bar. Round to 2 digits.
		new_planet_row.set_value(6, "#{planet.pct_cpu_usage.round(2)} %")
		
		# Amount to fill progress bar. Must be an Int or GTK gets mad.
		if (planet.pct_cpu_usage > 100)
		  new_planet_row.set_value(7, 100)
		else
		  new_planet_row.set_value(7, planet.pct_cpu_usage.to_int)
		end
		
		new_planet_row.set_value(8, planet.num_extractors)
		new_planet_row.set_value(9, planet.num_factories)
		new_planet_row.set_value(10, planet.num_storages)
		new_planet_row.set_value(11, planet.num_launchpads)
	  end
	end
  end
  
  def start_observing_model
	@pi_configuration_model.add_observer(self)
  end
  
  def stop_observing_model
	@pi_configuration_model.delete_observer(self)
  end
  
  def calculate_planet_image_filename(planet_type)
	return "view/images/32x32/" + "#{TYPE_TO_FILENAME[planet_type]}"
  end
  
  def destroy
	self.stop_observing_model
  end
end