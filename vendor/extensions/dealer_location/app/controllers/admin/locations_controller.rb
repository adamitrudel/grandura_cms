class Admin::LocationsController < Admin::ResourceController
  model_class Location
  
  before_filter :all_actions_redirect_to_index
  
  def all_actions_redirect_to_index
    params[:redirect_to] = admin_locations_url
  end
  
  def destroy
    @location = Location.find(params[:id])
    flash[:notice] = "Location #{@location.name} was successfully destroyed."
    @location.destroy
    redirect_to admin_locations_url
  end
end