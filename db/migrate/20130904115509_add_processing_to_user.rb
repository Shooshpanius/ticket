class AddProcessingToUser < ActiveRecord::Migration
  def change
    add_column :users, :processing, :integer
  end
end
