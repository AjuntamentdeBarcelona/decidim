# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      class DestroyProposalState < Decidim::Command
        # Initializes an UpdateResult Command.
        #
        # result - The current instance of the proposal state to be destroyed.
        # current_user - the user performing the action
        def initialize(state, current_user)
          @state = state
          @current_user = current_user
        end

        # Destroys the result.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          Decidim.traceability.perform_action!(
            :delete,
            @state,
            @current_user
          ) do
            @state.destroy!
          end

          broadcast(:ok)
        end
      end
    end
  end
end
