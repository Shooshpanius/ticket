class CreateActualTasks < ActiveRecord::Migration
  def change
    create_table :actual_tasks do |t|
      t.belongs_to :user
      t.belongs_to :ticket_to_group
      t.belongs_to :ticket_to_user
      t.timestamps
    end
  end
end
