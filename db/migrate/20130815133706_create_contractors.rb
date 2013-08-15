class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.integer :user_id
      t.string :login
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :city
      t.integer :state_id
      t.string :postal_code
      t.string :company_name
      t.text :company_description
      t.string :website
      t.string :phone
      t.string :mobile
      t.integer :mobile_carrier_id
      t.string :fax
      t.string :insurance_certificate
      t.integer :amount_insured_for
      t.date :date_insured_from
      t.date :date_insured_to
      t.string :license_number
      t.string :logo
      t.string :status
      t.integer :sales_person_id

      t.timestamps
    end

    add_index :contractors, :sales_person_id

  end
end
