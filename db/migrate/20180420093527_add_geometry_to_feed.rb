class AddGeometryToFeed < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :geometry, :string
  end
end
