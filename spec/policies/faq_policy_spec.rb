# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaqPolicy do
  subject { described_class.new(nil, Faq.new) }

  permissions :index? do
    it 'allows access for everyone' do
      expect(subject.index?).to eq(true)
    end
  end
end
