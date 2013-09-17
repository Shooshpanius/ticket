class AddRootToAttache < ActiveRecord::Migration
  def change
    add_column :attaches, :root, :integer
  end
end
