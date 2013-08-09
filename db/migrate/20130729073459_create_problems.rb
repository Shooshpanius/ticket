class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.belongs_to :user
      t.string :topic
      t.text :text
      t.boolean :status


      t.timestamps
    end
  end
end
