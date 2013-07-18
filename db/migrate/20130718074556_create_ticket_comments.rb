class CreateTicketComments < ActiveRecord::Migration
  def change
    create_table :ticket_comments do |t|


      t.belongs_to :ticket_to_groups
      t.belongs_to :ticket_to_users

      t.timestamps
    end
  end
end
