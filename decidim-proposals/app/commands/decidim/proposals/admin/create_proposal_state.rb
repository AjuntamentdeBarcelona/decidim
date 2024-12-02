# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      class CreateProposalState < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the proposal.
        # - :invalid if the form was not valid and we could not proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if @form.invalid?

          transaction do
            Decidim.traceability.create!(
              Decidim::Proposals::ProposalState,
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
