class CreateSupplyData < ActiveRecord::Migration
  def change
    create_table :supply_data do |t|

      t.integer :ticket_id
      t.integer :root

      t.string :name
      t.string :spec
      t.string :measure
      t.string :cnt
      t.string :estimated_date
      t.string :supplier


      t.timestamps
    end
  end
end
