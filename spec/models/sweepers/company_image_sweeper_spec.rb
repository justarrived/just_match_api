# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::CompanyImageSweeper do
  describe '#destroy_orphans' do
    let(:company) { FactoryBot.create(:company) }

    it 'destroys all orphanes' do
      FactoryBot.create(:company_image)
      FactoryBot.create(:company_image, created_at: 2.days.ago)
      FactoryBot.create(:company_image, created_at: 2.days.ago)
      FactoryBot.create(:company_image, company: company)

      expect do
        described_class.destroy_orphans
      end.to change(CompanyImage, :count).by(-2)
    end
  end
end
