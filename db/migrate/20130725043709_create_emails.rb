class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :topic
      t.string :text
      t.timestamps
    end
  end
end
