class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :question_id
  		t.integer :possible_response_id
  		t.integer :created_by
  		t.datetime :created_at
  		t.integer :updated_by
  		t.datetime :updated_at
  		t.integer :lock_version
  		t.integer :position

      t.timestamps
    end
  end
end
