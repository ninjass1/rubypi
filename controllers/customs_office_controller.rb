require_relative '../view/customs_office_view/customs_office_view.rb'

class CustomsOfficeController
  
  attr_reader :view
  
  def initialize(building_model)
	# Store the model.
	@building_model = building_model
	
	@view = CustomsOfficeView.new(self)
	@view.building_model = @building_model
	
	# Begin observing the model.
	self.start_observing_model
  end
  
  # Actions the view can call.
  def change_tax_rate(new_rate)
	@building_model.tax_rate=(new_rate)
  end
  
  def store_product(product_name, quantity)
	begin
	  @building_model.store_product(product_name, quantity)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def remove_qty_of_product(product_name, quantity)
	begin
	  @building_model.remove_qty_of_product(product_name, quantity)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def up_to_planet_controller
	$ruby_pi_main_gtk_window.load_controller_for_model(@building_model.planet)
  end
  
  
  # Model observation methods.
  def start_observing_model
	@building_model.add_observer(self, "on_model_changed")
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  def on_model_changed
	# Pass the model up to the view.
	@view.building_model = @building_model
  end
  
  # Destructor.
  def destroy
	self.stop_observing_model
	
	# Destroy the view.
	@view.destroy
  end
end