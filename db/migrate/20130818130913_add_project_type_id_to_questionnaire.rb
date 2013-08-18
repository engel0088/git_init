class AddProjectTypeIdToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :project_type_id, :integer
  end
end
