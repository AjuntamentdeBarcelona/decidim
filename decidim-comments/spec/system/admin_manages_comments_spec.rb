# frozen_string_literal: true

require "spec_helper"

describe "Admin manages comments" do
  let(:manifest_name) { "dummy" }
  let!(:dummy) { create(:dummy_resource, component: current_component) }
  let!(:resources) { create_list(:dummy_resource, 2, component: current_component) }
  let!(:reportables) do
    resources.map do |resource|
      create(:comment, commentable: resource)
    end
  end
  let(:participatory_space_path) do
    decidim_admin_participatory_processes.edit_participatory_process_path(participatory_process)
  end

  include_context "when managing a component as an admin"

  it_behaves_like "manage moderations"

  it_behaves_like "sorted moderations" do
    let!(:reportables) { create_list(:dummy_resource, 27, component: current_component) }
  end
end
