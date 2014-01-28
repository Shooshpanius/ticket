class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|


      t.integer :sender_id
      t.integer :recipient_id
      t.integer :ticket_root_id
      t.datetime :start_scheduler
      t.datetime :stop_scheduler


      t.timestamps
    end
  end
end
