class Dealer < ActiveRecord::Base
  validates_uniqueness_of :company
  validates_presence_of :company, :contact_person, :phone, :address, :location
  
  belongs_to :location
end