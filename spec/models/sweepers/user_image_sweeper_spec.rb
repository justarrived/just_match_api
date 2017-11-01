# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::UserImageSweeper do
  describe '#destroy_orphans' do
    let(:user) { FactoryBot.create(:user) }

    it 'destroys all orphanes' do
      FactoryBot.create(:user_image)
      FactoryBot.create(:user_image, created_at: 2.days.ago)
      FactoryBot.create(:user_image, created_at: 2.days.ago)
      FactoryBot.create(:user_image, user: user)

      expect do
        described_class.destroy_orphans
      end.to change(UserImage, :count).by(-2)
    end
  end
end
