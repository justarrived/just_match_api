# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NilNotifier do
  subject { NilNotifier }

  it 'accepts any keyword arguments' do
    expect(subject.call(wat: nil, man: nil)).to eq(nil)
  end

  it 'does not accept regular arguments' do
    expect { subject.call(nil) }.to raise_error(ArgumentError)
  end
end
