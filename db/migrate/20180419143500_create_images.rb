class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :file_name
      t.string :geometry
      t.integer :feed_id

      t.timestamps
    end
  end
end
