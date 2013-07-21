class CreateTicketComments < ActiveRecord::Migration
  def change
    create_table :ticket_comments do |t|


      t.belongs_to :ticket_to_group
      t.belongs_to :ticket_to_user
      t.string :text
      t.belongs_to :users




      t.timestamps
    end
  end
end