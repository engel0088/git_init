# [FIXME] below module

module Comatose
  class Page < ActiveRecord::Base
    set_table_name 'comatose_pages'
    acts_as_versioned :if_changed => [:title, :slug, :keywords, :body]
  end
end

class AddComatoseSupport < ActiveRecord::Migration

  # Schema for Comatose version 0.7+
  def change
    create_table :comatose_pages do |t|
      t.column "parent_id",   :integer
      t.column "full_path",   :text,   :default => ''
      t.column "title",       :string, :limit => 255
      t.column "slug",        :string, :limit => 255
      t.column "keywords",    :string, :limit => 255
      t.column "body",        :text
      t.column "filter_type", :string, :limit => 25, :default => "Textile"
      t.column "author",      :string, :limit => 255
      t.column "position",    :integer, :default => 0
      t.column "version",     :integer
      t.column "updated_on",  :datetime
      t.column "created_on",  :datetime
    end
    Comatose::Page.create_versioned_table
    puts "Creating the default 'Home Page'..."

    p=Comatose::Page.new
    p.title= 'Home Page'
    p.body="h1. Welcome\n\nYour content goes here..."
    p.author='System' 
    p.save

  end

end
