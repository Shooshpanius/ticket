class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
#      t.integer :id
      t.string :login
      t.string :f_name
      t.string :i_name
      t.string :o_name
      t.integer :position_id
      t.string :password
      t.boolean :status
      t.string :email
      t.string :ticket_email
      t.string :ticket_email_password
      t.boolean :admin
      t.string :position
      t.string :department
      t.string :auth_hash
      t.string :auth_last_ip
      t.timestamps
    end
  end
end
