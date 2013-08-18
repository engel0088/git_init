class AddFlagModelToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :flag_model, :boolean
    add_column :contractors, :mobile_hide, :boolean

    remove_column :monopolies, :project_type_id
    add_column :monopolies, :category_id, :integer
    add_index :monopolies, :category_id

    rename_column :questions, :text, :name

    remove_column :orders, :expiration
    add_column :orders, :start_date, :date
    add_column :orders, :end_date, :date
    add_column :orders, :payment_method, :string
    add_column :orders, :order_type, :string
    add_column :orders, :billing_name, :string
    add_column :orders, :billing_address, :string
    add_column :orders, :billing_city, :string
    add_column :orders, :billing_state_id, :integer
    add_column :orders, :billing_zip, :string

    rename_column :anonymous_questionnaires, :anonymous_id, :lead_id
    add_index :anonymous_questionnaires, :lead_id
    add_index :anonymous_questionnaires, :question_id

    add_column :leads, :contractor_id, :integer
    add_index :leads, :contractor_id

    remove_column :orders, :credit_card_expiration
    add_column :orders, :credit_card_month_exp, :integer
    add_column :orders, :credit_card_year_exp, :integer

    rename_column "payments", "method", "payment_method"

    add_column :orders, :agreement_sent_at, :datetime

    add_column :orders, :type, :string

    rename_column :sales_people, :commission_rate, :commission_rate_new_account
    add_column :sales_people, :commission_rate_reorder, :integer
    add_column :sales_people, :commission_rate_renewal, :integer

    add_column :payments, :cheque_number, :string

    add_column :orders, :commission_payment_id, :integer

    add_column :orders, :original_order_id, :integer


  end
end
