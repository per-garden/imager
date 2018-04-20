class RemoveGeometryFromImage < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :geometry
  end
end
