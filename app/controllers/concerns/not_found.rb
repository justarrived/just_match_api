module NotFound
  NOT_FOUND_CODE = :not_found

  def self.add(errors)
    errors.tap do |errors|
      errors.add(
        status: 404,
        code: NOT_FOUND_CODE,
        detail: I18n.t('record_not_found')
      )
    end
  end
end
