class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.string :name
      t.integer :count
      t.references :image

      t.timestamps
    end
  end
end
