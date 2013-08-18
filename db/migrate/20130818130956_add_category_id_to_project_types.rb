class AddCategoryIdToProjectTypes < ActiveRecord::Migration
  def change
    add_column :project_types, :category_id, :integer
  end
end
