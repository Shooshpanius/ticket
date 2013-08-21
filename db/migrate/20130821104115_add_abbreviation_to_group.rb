class AddAbbreviationToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :abbreviation, :string
  end
end
