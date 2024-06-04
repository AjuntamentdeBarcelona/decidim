# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Admin
    describe OrganizationController, type: :controller do
      routes { Decidim::Admin::Engine.routes }

      let(:organization) { create :organization }
      let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }
      let(:parsed_response) { JSON.parse(response.body).map(&:symbolize_keys) }

      shared_context "with daisy" do
        let!(:daisy) { create(:user, name: "Daisy", nickname: "daisy", organization: organization, email: "daisy@example.org") }
      end

      before do
        request.env["decidim.current_organization"] = organization
        sign_in current_user, scope: :user
      end

      describe "GET users and user groups in json format" do
        let!(:user) { create(:user, name: "Daisy Miller", nickname: "daisy_m", organization: organization, email: "d.mail@example.org") }
        let!(:blocked_user) { create(:user, :blocked, name: "Daisy Blocked", nickname: "daisy_b", organization: organization, email: "d.mail.b@example.org") }
        let!(:managed_user) { create(:user, :managed, name: "Daisy Managed", nickname: "daisy_g", organization: organization, email: "d.mail.g@example.org") }
        let!(:deleted_user) { create(:user, :deleted, name: "Daisy Deleted", nickname: "daisy_d", organization: organization, email: "d.mail.d@example.org") }
        let!(:other_user) { create(:user, name: "Daisy O'connor", nickname: "daisy_o", email: "d.mail.o@example.org") }
        let!(:user_group) do
          create(
            :user_group,
            :verified,
            name: "Daisy Organization",
            nickname: "daisy_org",
            email: "d.mail.org@example.org",
            users: [user],
            organization: organization
          )
        end

        context "when searching by name" do
          context "when finding by full name" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :user_entities, format: :json, params: { term: "Daisy" }
              expect(parsed_response.count).to eq(3)
              expect(parsed_response.first[:value]).to eq(daisy.id)
            end
          end

          it "returns the id, name and nickname for filtered users and user groups" do
            get :user_entities, format: :json, params: { term: "daisy" }
            expect(parsed_response).to include({ value: user.id, label: "#{user.name} (@#{user.nickname})" })
            expect(parsed_response).to include({ value: user_group.id, label: "#{user_group.name} (@#{user_group.nickname})" })
            expect(parsed_response).not_to include({ value: other_user.id, label: "#{other_user.name} (@#{other_user.nickname})" })
            expect(parsed_response).not_to include({ value: blocked_user.id, label: "#{blocked_user.name} (@#{blocked_user.nickname})" })
            expect(parsed_response).not_to include({ value: deleted_user.id, label: "#{deleted_user.name} (@#{deleted_user.nickname})" })
            expect(parsed_response).not_to include({ value: managed_user.id, label: "#{managed_user.name} (@#{managed_user.nickname})" })
          end
        end

        context "when searching by nickname" do
          it "returns the id, name and nickname for filtered users and user groups" do
            get :user_entities, format: :json, params: { term: "@daisy" }
            expect(parsed_response).to include({ value: user.id, label: "#{user.name} (@#{user.nickname})" })
            expect(parsed_response).to include({ value: user_group.id, label: "#{user_group.name} (@#{user_group.nickname})" })
            expect(parsed_response).not_to include({ value: other_user.id, label: "#{other_user.name} (@#{other_user.nickname})" })
            expect(parsed_response).not_to include({ value: blocked_user.id, label: "#{blocked_user.name} (@#{blocked_user.nickname})" })
            expect(parsed_response).not_to include({ value: deleted_user.id, label: "#{deleted_user.name} (@#{deleted_user.nickname})" })
            expect(parsed_response).not_to include({ value: managed_user.id, label: "#{managed_user.name} (@#{managed_user.nickname})" })
          end

          context "when finding by full nickname" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :user_entities, format: :json, params: { term: "@daisy" }
              expect(parsed_response.count).to eq(3)
              expect(parsed_response.first[:value]).to eq(daisy.id)
            end
          end
        end

        context "when searching by email" do
          it "returns the id, name and nickname for filtered users and user groups" do
            get :user_entities, format: :json, params: { term: "d.mail" }
            expect(parsed_response).to include({ value: user.id, label: "#{user.name} (@#{user.nickname})" })
            expect(parsed_response).to include({ value: user_group.id, label: "#{user_group.name} (@#{user_group.nickname})" })
            expect(parsed_response).not_to include({ value: other_user.id, label: "#{other_user.name} (@#{other_user.nickname})" })
            expect(parsed_response).not_to include({ value: blocked_user.id, label: "#{blocked_user.name} (@#{blocked_user.nickname})" })
            expect(parsed_response).not_to include({ value: deleted_user.id, label: "#{deleted_user.name} (@#{deleted_user.nickname})" })
            expect(parsed_response).not_to include({ value: managed_user.id, label: "#{managed_user.name} (@#{managed_user.nickname})" })
          end

          context "when finding by full email" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :user_entities, format: :json, params: { term: "daisy@example.org" }
              expect(parsed_response.count).to eq(1)
              expect(parsed_response.first[:value]).to eq(daisy.id)
            end
          end
        end

        context "when user is blocked" do
          let!(:user) { create(:user, :blocked, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end

        context "when user is managed" do
          let!(:user) { create(:user, :managed, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end

        context "when user is deleted" do
          let!(:user) { create(:user, :deleted, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end
      end

      describe "GET users in json format" do
        let!(:user) { create(:user, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }
        let!(:other_user) { create(:user, name: "Daisy O'connor", nickname: "daisy_o") }
        let!(:user_group) do
          create(
            :user_group,
            :verified,
            name: "Daisy Organization",
            nickname: "daysy_org",
            users: [user],
            organization: organization
          )
        end

        context "when no search term is provided" do
          it "returns an empty result set" do
            get :users, format: :json, params: {}
            expect(parsed_response).to eq([])
          end
        end

        context "when there are no results" do
          it "returns an empty json array" do
            get :users, format: :json, params: { term: "#0" }
            expect(parsed_response).to eq([])
          end
        end

        context "when searching by name" do
          it "returns the id, name and nickname for filtered users" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([{ value: user.id, label: "#{user.name} (@#{user.nickname})" }])
          end

          context "when there is more than one result" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :users, format: :json, params: { term: "daisy" }
              expect(parsed_response).to eq([{ value: daisy.id, label: "#{daisy.name} (@#{daisy.nickname})" }, { value: user.id, label: "#{user.name} (@#{user.nickname})" }])
            end
          end
        end

        context "when searching by nickname" do
          it "returns the id, name and nickname for filtered users" do
            get :users, format: :json, params: { term: "@daisy" }
            expect(parsed_response).to eq([{ value: user.id, label: "#{user.name} (@#{user.nickname})" }])
          end

          context "when there is more than one result" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :users, format: :json, params: { term: "@daisy" }
              expect(parsed_response).to eq([{ value: daisy.id, label: "#{daisy.name} (@#{daisy.nickname})" }, { value: user.id, label: "#{user.name} (@#{user.nickname})" }])
            end
          end
        end

        context "when searching by email" do
          it "returns the id, name and nickname for filtered users" do
            get :users, format: :json, params: { term: user.email }
            expect(parsed_response).to eq([{ value: user.id, label: "#{user.name} (@#{user.nickname})" }])
          end

          context "when there is more than one result" do
            include_context "with daisy"

            it "returns the results ordered by similarity" do
              get :users, format: :json, params: { term: "daisy@example.org" }
              expect(parsed_response).to eq([{ value: daisy.id, label: "#{daisy.name} (@#{daisy.nickname})" }])
            end
          end
        end

        context "when user is blocked" do
          let!(:user) { create(:user, :blocked, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end

        context "when user is managed" do
          let!(:user) { create(:user, :managed, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end

        context "when user is deleted" do
          let!(:user) { create(:user, :deleted, name: "Daisy Miller", nickname: "daisy_m", organization: organization) }

          it "returns an empty json array" do
            get :users, format: :json, params: { term: "daisy" }
            expect(parsed_response).to eq([])
          end
        end
      end
    end
  end
end
