# frozen_string_literal: true

require "spec_helper"

describe "Explore Budgets", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "budgets" }

  let!(:component) do
    create(:budgets_component,
           :with_vote_threshold_percent,
           :with_landing_page_content,
           manifest: manifest,
           participatory_space: participatory_process,
           landing_page_content: { en: "<h1>Big title</h1>" },
           landing_page_instructions: { en: "<p>Follow your instincts</p>" })
  end

  let!(:current_step) do
    create(:participatory_process_step,
      start_date: 1.day.ago,
      end_date: 3.days.from_now,
      participatory_process: participatory_process
    )
  end

  before do
    participatory_process.steps.first.update(start_date: 1.month.ago, end_date: 1.day.ago - 1.hour, active: false)
    participatory_process.steps.last.update(active: true)
  end

  context "with only one budget" do
    let!(:budgets) { create_list(:budget, 1, component: component) }

    it "redirects to the only budget details" do
      visit_component

      expect(page).to have_content("More information")
    end
  end

  context "with many budgets" do
    let!(:budgets) do
      1.upto(6).to_a.map { |x| create(:budget, component: component, total_budget: x * 10_000_000, description: { en: "This is budget #{x}" }) }
    end

    before do
      visit_component
    end

    it "shows the content" do
      expect(page).to have_content("Big title")
    end

    it "shows the dates" do
      expect(page).to have_content("Voting dates")
      
      within ".extra__date-container" do
        expect(page).to have_content(I18n.l(current_step.start_date, format: "%B"))
        expect(page).to have_content(current_step.start_date.day)
        expect(page).to have_content(I18n.l(current_step.end_date, format: "%B"))
        expect(page).to have_content(current_step.end_date.day)
      end
    end

    it "shows the instructions" do
      expect(page).to have_content("How to participate")
      expect(page).to have_content("Follow your instincts")
    end

    it "lists all the budgets" do
      expect(page).to have_selector(".card--list__item", count: 6)

      budgets.each do |budget|
        expect(page).to have_content(translated(budget.title))
        expect(page).to have_content("This is budget 1")
        expect(page).to have_content("€10,000,000")
      end
    end

    describe "budget list item" do
      let(:budget) { budgets.first }
      let(:item) { page.find(".budget-list .card--list__item:first-child", match: :first) }
      let!(:projects) { create_list(:project, 3, budget: budget, budget_amount: 10_000_000) }

      before do
        login_as user, scope: :user
      end

      it "has a clickable title" do
        expect(item).to have_link(translated(budget.title), href: budget_path(budget))
      end

      context "when an item is bookmarked" do
        let!(:order) { create(:order, user: user, budget: budget) }
        let!(:line_item) { create(:line_item, order: order, project: projects.first) }

        it "shows the bookmark icon" do
          visit_component

          expect(item).to have_selector(".budget-list__icon .icon--bookmark")
          expect(item).to have_link("Finish voting", href: budget_path(budget))
        end
      end

      context "when an item is voted" do
        let(:item) { page.find("#voted-budgets .card--list__item:first-child") }

        let!(:order) do
          order = create(:order, user: user, budget: budget)
          order.projects = [projects.first]
          order.checked_out_at = Time.current
          order.save!
          order
        end

        it "shows the check icon" do
          visit_component

          expect(item).to have_selector(".budget-list__icon .icon--check")
          expect(item).to have_link("Show", href: budget_path(budget))
        end
      end
    end
  end

  context "when directly accessing from URL with an invalid budget id" do
    it_behaves_like "a 404 page" do
      let(:target_path) { Decidim::EngineRouter.main_proxy(component).budget_path(99_999_999) }
    end
  end

  def budget_path(budget)
    Decidim::EngineRouter.main_proxy(component).budget_path(budget.id)
  end
end
