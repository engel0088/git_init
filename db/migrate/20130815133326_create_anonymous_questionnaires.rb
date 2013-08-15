class CreateAnonymousQuestionnaires < ActiveRecord::Migration
  def change
    create_table :anonymous_questionnaires do |t|

      t.timestamps
    end
  end
end
