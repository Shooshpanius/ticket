class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :topic
      t.string :text

      t.timestamps
    end
  end
end
