class CreateDealers < ActiveRecord::Migration
  def self.up
    create_table :dealers do |t|
      t.string :company
      t.string :contact_person
      t.string :phone
      t.string :address

      t.boolean :windows
      t.boolean :siding
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :dealers    
  end
end