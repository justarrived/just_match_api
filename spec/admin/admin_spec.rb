# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin' do
  model_names = %w(
    Category Chat CommentTranslation CommunicationTemplate
    CommunicationTemplateTranslation Company CompanyImage Contact Document
    Faq FaqTranslation Filter FilterUser FrilansFinansApiLog FrilansFinansInvoice
    FrilansFinansTerm HourlyPay Interest InterestFilter InterestTranslation Invoice
    Job JobRequest JobTranslation JobUser JobUserTranslation Language LanguageFilter
    Message MessageTranslation Rating ReceivedEmail ReceivedText Skill SkillFilter
    SkillTranslation Tag TermsAgreement TermsAgreementConsent Token User UserDocument
    UserImage UserInterest UserLanguage UserSkill UserTag UserTranslation Comment
  )

  model_names.each do |model_name|
    result = ActiveAdmin.application.namespaces[:admin].resources.keys.map(&:name)

    it "has admin resource for #{model_name}" do
      expect(result).to include(model_name)
    end
  end

  model_names.each do |model_name|
    describe "Admin::#{model_name.pluralize}Controller".constantize, type: :controller do
      let(:resource_class) { model_name.constantize }
      let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
      let(:resource)       { all_resources[resource_class] }

      describe '#index' do
        subject do
          password = '12345678'
          user = FactoryBot.create(:admin_user, password: password)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, password) # rubocop:disable Metrics/LineLength
          get :index
        end
        it { expect(subject).to be_successful }
      end

      show_ignores = %(Comment Ratings)
      unless show_ignores.include?(model_name)
        describe '#show' do
          subject do
            password = '12345678'
            user = FactoryBot.create(:admin_user, password: password)
            request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, password) # rubocop:disable Metrics/LineLength

            resource = FactoryBot.create(model_name.constantize.model_name.singular)
            get :show, params: { id: resource.id }
          end
          it { expect(subject).to be_successful }
        end
      end
    end
  end
end
