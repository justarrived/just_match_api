# frozen_string_literal: true

class MetrojobbCategories
  NAMES = {
    'Administration' => '1800',
    'Bygg & Anläggning' => '1801',
    'Data / IT' => '1802',
    'Drift & Underhåll' => '1803',
    'Ekonomi & Finans' => '1804',
    'Försäkringar' => '509',
    'Säljare / Account manager' => '700',
    'Sjukvård & Hälsa' => '1818',
    'Hotell / Restaurang / Turism' => '1807',
    'HR & Personal' => '1808',
    'Juridik' => '1809',
    'Industri / Produktion' => '1821',
    'Marknadsföring / Produkt' => '1815',
    'Webbdesigner / Grafisk designer' => '310',
    'Utvecklare / Programmerare' => '305',
    'Byggnad / konstruktion' => '214',
    'IT-konsult' => '300',
    'Målare / Golvläggare' => '208',
    'Ledning / Chefer' => '1813',
    'Säkerhet & Kontroll' => '1812',
    'Kundsupport & Service' => '1811',
    'Teknik' => '1820',
    'Logistik / Transport' => '1814',
    'Kreativitet / Design' => '1810',
    'Försäljning / Affärsutveckling' => '1806',
    'Lärare / Utbildning' => '1822',
    'Övrigt' => '2402'
  }.freeze

  def self.to_form_array
    NAMES.keys.zip(NAMES.keys)
  end
end
