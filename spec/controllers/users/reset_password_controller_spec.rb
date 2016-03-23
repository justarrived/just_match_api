# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::ResetPasswordController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.build(:user) }

    let(:valid_attributes) do
      {
        data: {
          attributes: {
            token: user.one_time_token
          }
        }
      }
    end

    context 'with valid params' do
      it ''
    end

    context 'with invalid params' do
    end
  end
end
