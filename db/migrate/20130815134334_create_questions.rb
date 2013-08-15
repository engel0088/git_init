class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
  		t.text :text
  		t.integer :position
  		t.integer :created_by
  		t.datetime :created_at
  		t.integer :updated_by
  		t.datetime :updated_at
  		t.integer :lock_version
  		
  		t.integer :questionnaire_id
  		t.integer :question_type_id

      t.timestamps
    end
    add_index :questions, :questionnaire_id
    add_index :questions, :question_type_id

  end
end
