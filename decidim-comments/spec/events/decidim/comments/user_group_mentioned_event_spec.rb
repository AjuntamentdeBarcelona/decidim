# frozen_string_literal: true

require "spec_helper"

describe Decidim::Comments::UserGroupMentionedEvent do
  include_context "when it's a comment event"
  let(:organization) { create(:organization) }
  let(:event_name) { "decidim.events.comments.user_group_mentioned" }
  let(:ca_comment_content) { "<div><p>Un commentaire pour #{author_link}</p></div>" }
  let(:en_comment_content) { "<div><p>Comment mentioning some user group, #{author_link}</p></div>" }
  let(:author_link) { "<a class=\"user-mention\" href=\"http://#{organization.host}:#{Capybara.server_port}/profiles/#{group.nickname}\">@#{group.nickname}</a>" }

  let(:extra) do
    {
      comment_id: comment.id,
      group_id: group.id
    }
  end

  let(:group) { create :user_group, organization: organization, users: members + [user] }
  let(:members) { create_list :user, 2, organization: organization }
  let(:user) { create :user, organization: organization, locale: "ca" }

  let(:parsed_body) { Decidim::ContentProcessor.parse("Comment mentioning some user group, @#{group.nickname}", current_organization: organization) }
  let(:parsed_ca_body) { Decidim::ContentProcessor.parse("Un commentaire pour @#{group.nickname}", current_organization: organization) }
  let(:body) { { en: parsed_body.rewrite, machine_translations: { ca: parsed_ca_body.rewrite } } }
  let(:email_subject) { "You have been mentioned in #{resource_title} as a member of #{html_escape(group.name)}" }
  let(:email_intro) { "A group you belong to has been mentioned" }
  let(:email_outro) { "You have received this notification because you are a member of the group #{html_escape(group.name)} that has been mentioned in #{resource_title}." }

  it_behaves_like "a comment event"
  it_behaves_like "a simple event email"

  describe "resource_text" do
    let(:participatory_process) { create :participatory_process, organization: organization }
    let(:component) { create(:component, participatory_space: participatory_process) }
    let(:commentable) { create(:dummy_resource, component: component) }
    let!(:comment) { create :comment, body: body, commentable: commentable }

    it "correctly renders comments with mentions" do
      expect(subject.resource_text).not_to include("gid://")
      expect(subject.resource_text).to include("@#{group.nickname}")
    end
  end

  describe "translated notifications" do
    let(:en_body) { parsed_body.rewrite }

    let(:body) { { en: en_body, machine_translations: { ca: parsed_ca_body.rewrite } } }
    let(:participatory_process) { create :participatory_process, organization: organization }
    let(:component) { create(:component, participatory_space: participatory_process) }
    let(:commentable) { create(:dummy_resource, component: component) }
    let(:comment) { create :comment, body: body, commentable: commentable }
    let(:en_version) { en_comment_content }
    let(:translatable) { true }
    let(:machine_translated) { ca_comment_content }

    it_behaves_like "a translated event"
  end

  describe "notification_title" do
    it "is generated correctly" do
      expect(subject.notification_title)
        .to include("You have been mentioned in <a href=\"#{resource_path}?commentId=#{comment.id}#comment_#{comment.id}\">#{resource_title}</a>")

      expect(subject.notification_title)
        .to include(" as a member of <a href=\"/profiles/#{group.nickname}\">#{html_escape(group.name)} @#{group.nickname}</a>")

      expect(subject.notification_title)
        .to include(" by <a href=\"/profiles/#{comment_author.nickname}\">#{html_escape(comment_author.name)} @#{comment_author.nickname}</a>")
    end
  end
end
