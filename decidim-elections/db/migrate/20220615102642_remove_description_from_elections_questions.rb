# frozen_string_literal: true

class RemoveDescriptionFromElectionsQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_column :decidim_elections_questions, :description, :jsonb
  end
end
