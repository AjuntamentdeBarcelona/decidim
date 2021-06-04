# frozen_string_literal: true

require "spec_helper"

describe Decidim::FocusModeCell, type: :cell do
  subject { my_cell.call { "content" } }

  controller Decidim::Budgets::BudgetsController

  let(:my_cell) { cell("decidim/focus_mode", nil, options) }
  let!(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let(:options) { { title: "A title for focus mode", opener_button: opener_button, context: { current_user: user, current_organization: organization } } }
  let(:opener_button) { false }
  let(:decidim) { Decidim::Core::Engine.routes }

  it "renders the content passed as a block" do
    expect(subject).to have_content("content")
  end

  it "renders the title passed in the options" do
    expect(subject).to have_content("A title for focus mode")
  end

  it "renders the organization name linking to the home page" do
    expect(subject).to have_link(organization.name, href: "http://#{organization.host}/")
  end

  context "when opener_button option is false" do
    let(:opener_button) { false }

    it "does not render the opener button" do
      expect(subject).not_to have_css("[data-focus-open]")
    end
  end

  context "when opener_button option is true" do
    let(:opener_button) { true }

    it "renders the opener button" do
      expect(subject).to have_css("[data-focus-open]")
    end
  end

  context "when the user is logged in" do
    it "renders the user name with a link to the account page" do
      expect(subject).to have_css(".focus-mode__user")
      expect(subject).to have_link(user.name, href: "/account")
    end
  end

  context "when the user is not logged in" do
    let(:user) { nil }

    it "does not render the user name" do
      expect(subject).not_to have_css(".focus-mode__user")
    end
  end
end
