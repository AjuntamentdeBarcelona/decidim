# frozen_string_literal: true

class AddTitleToTimelineEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_accountability_timeline_entries, :title, :jsonb
  end
end
