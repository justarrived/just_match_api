# frozen_string_literal: true

class BlocketRegionCodes
  CODES = lambda do
    csv = HoneyFormat::CSV.new(File.read('data/blocket-regions.csv'))
    csv.rows.map(&:name).zip(csv.rows.map(&:to_h)).to_h
  end.call

  def self.to_municipality_code(name)
    find(name)[:id]
  end

  def self.to_region_code(name)
    find(name)[:region_id]
  end

  def self.to_region_name(name)
    find(name)[:region_name]
  end

  def self.find(name)
    CODES[name] || CODES["#{name} stad"] || CODES["#{name}s stad"] || {}
  end
end
