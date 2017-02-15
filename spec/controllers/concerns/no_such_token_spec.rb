# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NoSuchToken do
  describe '::add' do
    it 'adds and returns no such token error' do
      errors = described_class.add
      expect(errors.length).to eq(1)
      expect(errors.first.status).to eq(401)
      expect(errors.first.code).to eq(described_class::NO_SUCH_TOKEN)
    end

    it 'adds and returns no such token error and keeps existing errors' do
      prev_errors = JsonApiErrors.new
      prev_errors.add(status: 422, code: :watman, detail: 'Watman is dead')
      errors = described_class.add(prev_errors)
      expect(errors.length).to eq(2)
    end
  end
end
