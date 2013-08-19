class AddAmountTotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :amount_total, :float

    add_column :users, :reset_code, :string

    add_column :leads, :call_me, :string
    add_column :leads, :financing, :boolean

    add_column :categories, :permalink, :string
    Category.all.each do|c| 
      c.save
    end

    add_column :project_types, :permalink, :string
    ProjectType.all.each do |c|
      c.save
    end

    add_column :leads, :financer_id, :integer

    add_column :leads, :category_id, :integer
    add_column :leads, :guid, :string

    Lead.find(:all, :conditions => "category_id IS NULL").each do |lead|
      lead.save!
    end

    add_column :contractors, :deleted_at, :datetime
    add_column :leads, :deleted_at, :datetime    

    add_column :contractors, :other_phone, :string

    add_column :leads, :state_id, :integer
    
    Lead.all.each do |lead|
      zip = ZipCode.find_by_code(lead.postal_code)
      lead.state = State.find_by_code(zip.state_code)
      lead.save!      
    end

    add_column :keywords, :permalink, :string
    Keyword.find(:all, :order => "ID").each do |kw|
      kw.save
    end

    add_column :contractors, :fax_hide, :boolean

    add_column :contractors, :date_founded, :date

    add_column :contractors, :email_hide, :boolean

    remove_column :contractors, :login

    add_column :categories, :deleted_at, :datetime
    add_column :project_types, :deleted_at, :datetime
    #add_column :questionnaires, :deleted_at, :datetime
    #add_column :questions, :deleted_at, :datetime
    #add_column :responses, :deleted_at, :datetime

  end
end
