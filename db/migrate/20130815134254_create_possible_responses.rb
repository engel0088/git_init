class CreatePossibleResponses < ActiveRecord::Migration
  def change
    create_table :possible_responses do |t|
      t.string :response
    	t.integer :created_by
  		t.datetime :created_at
  		t.integer :updated_by
  		t.datetime :updated_at
  		t.integer :lock_version

      t.timestamps
    end
  end
end
