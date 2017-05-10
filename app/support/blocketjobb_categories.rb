# frozen_string_literal: true

class BlocketjobbCategories
  CATEGORIES = {
    'Administration' => '9250',
    'Bank, Finans & Försäkring' => '9550',
    'Bygg & Hantverk' => '9220',
    'Data & IT' => '9230',
    'Ekonomi' => '9240',
    'Försäljning' => '9260',
    'Hälsa & Sjukvård' => '9320',
    'Hotell & Restaurang' => '9310',
    'HR & Personal' => '9270',
    'Industri & Anläggning' => '9280',
    'Juridik' => '9330',
    'Marknadsföring' => '9340',
    'Media, Kultur & Design' => '9290',
    'Miljö & Djurvård' => '9530',
    'Offentlig Förvaltning' => '9570',
    'Organisation & ledning' => '9210',
    'Säkerhet & Skydd' => '9510',
    'Service & Kundtjänst' => '9370',
    'Teknik & Ingenjör' => '9350',
    'Transport & Logistik' => '9300',
    'Utbildning' => '9360',
    'Övrigt' => '9380'
  }.freeze

  def self.to_a
    CATEGORIES.keys
  end

  def self.to_form_array
    to_a.map { |category| [category, category] }
  end

  def self.to_code(name)
    CATEGORIES[name]
  end

  def self.to_code!(name)
    CATEGORIES.fetch(name)
  end
end
