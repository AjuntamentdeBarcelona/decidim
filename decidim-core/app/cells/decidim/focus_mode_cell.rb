# frozen_string_literal: true

require "decidim/diffy_extension"

module Decidim
  # This cell renders a dismissable overlay to highlight information about the current
  # action being performed by the user
  class FocusModeCell < Decidim::ViewModel
    include Cell::ViewModel::Partial
    include LayoutHelper

    def show(&block)
      render(&block)
    end

    def title
      options[:title]
    end

    def user
      return unless current_user

      link_to current_user.name, decidim.account_path
    end

    def opener_button
      options[:opener_button]
    end
  end
end
