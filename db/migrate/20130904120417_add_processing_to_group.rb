class AddProcessingToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :processing, :integer
  end
end
