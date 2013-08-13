class CreateAttaches < ActiveRecord::Migration
  def change
    create_table :attaches do |t|

      t.string :object_type
      t.integer :object_id
      t.string :original_filename
      t.string :filename
      t.string :mime

      t.timestamps
    end
  end
end
