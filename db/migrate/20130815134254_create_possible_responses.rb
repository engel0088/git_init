class CreatePossibleResponses < ActiveRecord::Migration
  def change
    create_table :possible_responses do |t|

      t.timestamps
    end
  end
end
