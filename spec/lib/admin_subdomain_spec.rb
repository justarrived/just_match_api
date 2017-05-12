# frozen_string_literal: true

require 'spec_helper'

require 'admin_subdomain'

RSpec.describe AdminSubdomain do
  describe '#matches?' do
    %w(admin admin-sandbox admin-staging admin-demo demo-admin).each do |subdomain|
      it "is true for '#{subdomain}' subdomain" do
        request = Struct.new(:subdomain).new(subdomain)
        expect(described_class.matches?(request)).to eq(true)
      end
    end

    %w(demo sandbox api-staging api demo-api).each do |subdomain|
      it "is false for '#{subdomain}' subdomain" do
        request = Struct.new(:subdomain).new(subdomain)
        expect(described_class.matches?(request)).to eq(false)
      end
    end
  end
end
