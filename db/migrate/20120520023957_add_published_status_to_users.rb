class AddPublishedStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :published, :boolean, :default => false
  end

  def self.down
    remove_column :users, :published
  end
end
