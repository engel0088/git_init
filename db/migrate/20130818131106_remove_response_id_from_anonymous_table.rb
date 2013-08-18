class RemoveResponseIdFromAnonymousTable < ActiveRecord::Migration
  def up
    remove_column :anonymous_questionnaires, :response_id
  end

  def down
  end
end
