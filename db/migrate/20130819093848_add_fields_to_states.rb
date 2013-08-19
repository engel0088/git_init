class AddFieldsToStates < ActiveRecord::Migration
  def change
    add_column :states, :name,  :string
    add_column :states, :code,  :string
  end
end
