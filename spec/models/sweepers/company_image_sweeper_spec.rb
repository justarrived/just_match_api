# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Sweepers::CompanyImageSweeper do
  describe '#destroy_orphans' do
    let(:company) { FactoryGirl.create(:company) }

    it 'destroys all orphanes' do
      FactoryGirl.create(:company_image)
      FactoryGirl.create(:company_image, created_at: 2.days.ago)
      FactoryGirl.create(:company_image, created_at: 2.days.ago)
      FactoryGirl.create(:company_image, company: company)

      expect do
        described_class.destroy_orphans
      end.to change(CompanyImage, :count).by(-2)
    end
  end
end
