# frozen_string_literal: true

module Decidim
  # Helpers related to focus mode
  module FocusModeHelper
    def focus_mode(opts, &body)
      cell(FocusModeCell, nil, opts).call do
        capture(&body)
      end
    end
  end
end
