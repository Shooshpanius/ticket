class CreateProblemsByRecipients < ActiveRecord::Migration
  def change
    create_table :problems_by_recipients do |t|

      t.timestamps
    end
  end
end
