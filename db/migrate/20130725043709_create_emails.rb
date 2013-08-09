class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :topic
      t.text :text
      t.boolean :status
      t.timestamps
    end
  end
end
