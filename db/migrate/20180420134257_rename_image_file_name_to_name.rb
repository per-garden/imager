class RenameImageFileNameToName < ActiveRecord::Migration[5.1]
  def change
    rename_column :images, :file_name, :name
  end
end
