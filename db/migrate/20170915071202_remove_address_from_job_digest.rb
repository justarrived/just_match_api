# frozen_string_literal: true

class RemoveAddressFromJobDigest < ActiveRecord::Migration[5.1]
  def change
    remove_reference :job_digests, :address, foreign_key: true
  end
end
