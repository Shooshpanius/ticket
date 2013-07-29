class CreateProblemsByRecipients < ActiveRecord::Migration
  def change
    create_table :problems_by_recipients do |t|
      t.belongs_to :user
      t.belongs_to :group

      t.timestamps
    end
  end
end
