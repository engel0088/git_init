class CreateAnonymousQuestionnaires < ActiveRecord::Migration
  def change
    create_table :anonymous_questionnaires do |t|
      t.integer :anonymous_id
      t.integer :question_id
      t.integer :response_id
      t.string :response_text

      t.timestamps
    end

    add_index :anonymous_questionnaires, :anonymous_id
  end
end
