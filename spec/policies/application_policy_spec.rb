# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicationPolicy do
  class MockModel
    def id
    end

    def where(*_args)
      OpenStruct.new(exists?: false)
    end
  end
  MockRecord = Struct.new(:id)

  before(:each) do
    allow_any_instance_of(MockModel).to(
      receive(:id).and_return(1)
    )
    allow(Pundit).to(
      receive(:policy_scope!).and_return(MockModel.new)
    )
  end

  subject { ApplicationPolicy.new(nil, MockRecord.new(1)) }

  it 'returns false for #index?' do
    expect(subject.index?).to eq(false)
  end

  it 'returns false for #show?' do
    expect(subject.show?).to eq(false)
  end

  it 'returns false for #create?' do
    expect(subject.create?).to eq(false)
  end

  it 'returns false for #update?' do
    expect(subject.update?).to eq(false)
  end

  it 'returns false for #destroy?' do
    expect(subject.destroy?).to eq(false)
  end

  it 'returns false for #user?' do
    expect(subject.send(:user?)).to eq(false)
  end

  it 'returns true for #no_user?' do
    expect(subject.send(:no_user?)).to eq(true)
  end

  it 'returns false for #admin?' do
    expect(subject.send(:admin?)).to eq(false)
  end

  describe ApplicationPolicy::Scope do
    subject { described_class.new(user, scope) }

    let(:user) { :user }
    let(:scope) { :scope }

    it 'returns scope' do
      expect(subject.scope).to eq(scope)
    end

    it 'returns user' do
      expect(subject.user).to eq(user)
    end

    it 'returns @solve when #resolve is called' do
      expect(subject.resolve).to eq(scope)
    end
  end
end
