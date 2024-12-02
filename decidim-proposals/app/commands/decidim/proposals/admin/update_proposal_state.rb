# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      class UpdateProposalState < Decidim::Command
        # Initializes an UpdateResult Command.
        #
        # form - The form from which to get the data.
        # state - The current instance of the proposal state to be updated.
        def initialize(form, state)
          @form = form
          @state = state
        end

        # Updates the result if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if @form.invalid?

          transaction do
            Decidim.traceability.update!(
              @state,
              @form.current_user,
              title: @form.title,
              text_color: @form.text_color,
              bg_color: @form.bg_color,
              announcement_title: @form.announcement_title,
              component: @form.current_component
            )
          end
          broadcast(:ok)
        end
      end
    end
  end
end
