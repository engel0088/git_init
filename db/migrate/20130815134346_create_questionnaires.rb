class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.string :name, :null => :no
  		t.integer :created_by
  		t.datetime :created_at
  		t.integer :updated_by
  		t.datetime :updated_at
  		t.integer :lock_version

      t.timestamps
    end
  end
end
