class CreateNewsletterAttachments < ActiveRecord::Migration
  def change
    create_table :newsletter_attachments do |t|

      t.timestamps
    end
  end
end
