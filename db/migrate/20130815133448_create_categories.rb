class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end

    #Category.create(name: "root",parent_id: 0)
    c=Category.new
    c.name ="root"
    c.save
  end
end
