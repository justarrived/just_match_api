# frozen_string_literal: true
require 'rails_helper'

[
  ChatDashboard, ChatUserDashboard, CommentDashboard, JobDashboard, JobSkillDashboard,
  JobUserDashboard, LanguageDashboard, MessageDashboard, SkillDashboard, UserDashboard,
  UserLanguageDashboard, UserSkillDashboard
].each do |dashboard_klass|
  RSpec.describe dashboard_klass do
    subject { described_class }

    it 'has ATTRIBUTE_TYPES constant' do
      expect(subject::ATTRIBUTE_TYPES).not_to be_nil
    end

    it 'has COLLECTION_ATTRIBUTES constant' do
      expect(subject::COLLECTION_ATTRIBUTES).not_to be_nil
    end

    it 'has SHOW_PAGE_ATTRIBUTES constant' do
      expect(subject::SHOW_PAGE_ATTRIBUTES).not_to be_nil
    end

    it 'has FORM_ATTRIBUTES constant' do
      expect(subject::FORM_ATTRIBUTES).not_to be_nil
    end
  end
end
