class CreateTicketToGroups < ActiveRecord::Migration
  def change
    create_table :ticket_to_groups do |t|
      t.belongs_to :groups
      t.string :topic
      t.string :text
      t.date :deadline
      t.timestamps
    end
  end
end
