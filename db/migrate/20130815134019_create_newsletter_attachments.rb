class CreateNewsletterAttachments < ActiveRecord::Migration
  def change
    create_table :newsletter_attachments do |t|
      t.string :content
      t.string :title

      t.timestamps
    end
  end
end
