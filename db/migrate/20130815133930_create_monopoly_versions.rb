class CreateMonopolyVersions < ActiveRecord::Migration
  def change
    create_table :monopoly_versions do |t|

      t.timestamps
    end
  end
end
