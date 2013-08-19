class AddFieldsToStates < ActiveRecord::Migration
  def change
    add_column :name, :states, :string
    add_column :code, :states, :string
  end
end
