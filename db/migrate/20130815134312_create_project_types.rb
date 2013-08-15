class CreateProjectTypes < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
      t.string :name
      t.integer :lock_version
      t.integer :position

      t.timestamps
    end
  end
end
