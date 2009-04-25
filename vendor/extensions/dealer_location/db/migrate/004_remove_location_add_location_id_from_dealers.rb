class RemoveLocationAddLocationIdFromDealers < ActiveRecord::Migration
  def self.up
    remove_column :dealers, :location
    add_column :dealers, :location_id, :integer
  end
  
  def self.down
    add_column :dealers, :location, :string
    remove_column :dealers, :location_id
  end
end