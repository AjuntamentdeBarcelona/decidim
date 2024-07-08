# frozen_string_literal: true

require "spec_helper"

describe "Organization scopes" do
  include Decidim::SanitizeHelper

  let(:admin) { create(:user, :admin, :confirmed) }
  let(:organization) { admin.organization }
  let!(:attributes) { attributes_for(:scope) }

  before do
    switch_to_host(organization.host)
  end

  describe "Managing scopes" do
    let!(:scope_type) { create(:scope_type, organization: admin.organization) }

    before do
      login_as admin, scope: :user
      visit decidim_admin.root_path
      click_link "Settings"
      click_link "Scopes"
    end

    it "can create new scopes" do
      click_link "Add"

      within ".new_scope" do
        fill_in_i18n :scope_name, "#scope-name-tabs", **attributes[:name].except("machine_translations")
        fill_in "Code", with: "MY-DISTRICT"
        select scope_type.name["en"], from: :scope_scope_type_id

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).to have_content(translated(attributes[:name]))
      end

      visit decidim_admin.root_path
      expect(page).to have_content("created the #{translated(attributes[:name])} scope")
    end

    context "with existing scopes" do
      let!(:scope) { create(:scope, organization:) }

      before do
        visit current_path
      end

      it "can edit them" do
        within find("tr", text: translated(scope.name)) do
          click_link "Edit"
        end

        within ".edit_scope" do
          fill_in_i18n :scope_name, "#scope-name-tabs", **attributes[:name].except("machine_translations")
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_content(translated(attributes[:name]))
        end

        visit decidim_admin.root_path
        expect(page).to have_content("updated the #{translated(attributes[:name])} scope")
      end

      it "can delete them" do
        within find("tr", text: translated(scope.name)) do
          accept_confirm { click_link "Delete" }
        end

        expect(page).to have_admin_callout("successfully")

        within "[data-content]" do
          expect(page).not_to have_content(translated(scope.name))
        end
      end

      it "can create a new subcope" do
        within find("tr", text: translated(scope.name)) do
          page.find("td:first-child a").click
        end

        click_link "Add"

        within ".new_scope" do
          fill_in_i18n :scope_name, "#scope-name-tabs", en: "My nice subdistrict",
                                                        es: "Mi lindo subdistrito",
                                                        ca: "El meu bonic subbarri"
          fill_in "Code", with: "MY-SUBDISTRICT"
          select scope_type.name["en"], from: :scope_scope_type_id

          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_content("My nice subdistrict")
        end
      end
    end
  end
end
