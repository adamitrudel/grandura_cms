class Location < ActiveRecord::Base
  validates_uniqueness_of :name
  
  def to_s
    name
  end
end