class AddAddressHideToContractors < ActiveRecord::Migration
  def change
    add_column :contractors, :address_hide, :boolean


  end
end
