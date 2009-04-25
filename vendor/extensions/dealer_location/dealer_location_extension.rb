# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class DealerLocationExtension < Radiant::Extension
  version "1.0"
  description "Dealer Location Module for granduraliving.com"
  url "http://emsolutions.ca/"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :dealers
      admin.resources :locations
    end
  end
  
  def activate
    admin.tabs.add "Dealers", "/admin/dealers", :after => "Layouts", :visibility => [:all]
    Page.send :include, DealerLocation::Tags
  end
  
  def deactivate
    admin.tabs.remove "Dealers"
  end
  
end
