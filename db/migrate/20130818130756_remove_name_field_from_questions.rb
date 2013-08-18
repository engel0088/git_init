class RemoveNameFieldFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :name
  end

  def down
  end
end
