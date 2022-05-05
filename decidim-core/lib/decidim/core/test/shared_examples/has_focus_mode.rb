# frozen_string_literal: true

require "spec_helper"

shared_examples_for "has focus mode" do |content|
  it "has the necessary elements" do
    expect(page).to have_selector("#focus-mode")
    expect(page).to have_selector("#off-focus-mode")
  end

  it "is opened by default" do
    within "#focus-mode" do
      expect(page).to have_content(content)
    end
  end

  it "can be closed" do
    expect(page).to have_selector(".focus-mode__close")

    page.find(".focus-mode__close").click

    within "#focus-mode" do
      expect(page).not_to have_content(content)
    end
    
    within "#off-focus-mode" do
      expect(page).to have_content(content)
    end
  end
end
