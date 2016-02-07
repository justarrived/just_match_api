require 'rails_helper'

RSpec.describe SkillPolicy do
  context 'anyone' do
    subject { SkillPolicy.new(nil, skill) }

    let(:skill) { FactoryGirl.build(:skill) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns true for show' do
      expect(subject.show?).to eq(true)
    end

    it 'returns false for create' do
      expect(subject.create?).to eq(false)
    end

    it 'returns false for update' do
      expect(subject.update?).to eq(false)
    end

    it 'returns false for destroy' do
      expect(subject.destroy?).to eq(false)
    end
  end

  context 'admin user' do
    subject { SkillPolicy.new(admin, skill) }

    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:skill) { FactoryGirl.build(:skill) }

    it 'returns true for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns update for update' do
      expect(subject.update?).to eq(true)
    end

    it 'returns true for destroy' do
      expect(subject.destroy?).to eq(true)
    end
  end
end
