# frozen_string_literal: true

module Decidim
  module Budgets
    # This cell renders the Budgets component header
    class BudgetsHeaderCell < BaseCell
      private

      def landing_page_content
        translated_attribute(current_settings.landing_page_content).presence || translated_attribute(settings.landing_page_content)
      end

      def landing_page_instructions
        translated_attribute(current_settings.landing_page_instructions).presence || translated_attribute(settings.landing_page_instructions)
      end
    end
  end
end
