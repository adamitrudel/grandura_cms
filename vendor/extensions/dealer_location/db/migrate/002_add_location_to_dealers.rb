class AddLocationToDealers < ActiveRecord::Migration
  def self.up
    add_column :dealers, :location, :string
  end
  
  def self.down
    remove_column :dealers, :location
  end
end