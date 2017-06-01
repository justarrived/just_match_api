# frozen_string_literal: true

module Wgtrm
  class User
    LanguageProficiency = Struct.new(:name, :proficiency)

    PROFICIENCY_MAP = {
      'Able to communicate' => 2,
      'Basic knowledge' => 3,
      'Able to negotiate' => 4,
      'Native speaker' => 5
    }.freeze

    LANGUAGE_NAME_MAP = {
      'Tigrigna' => 'Tigrinya',
      'Somali' => 'Somalia',
      'Slovene' => 'Slovenian',
      'Persian' => 'Farsi',
      'PashtuDari' => 'Dari',
      'Pashtu' => 'Pashto',
      'Chinese,' => 'Chinese',
      'Mandarin' => 'Chinese',
      'Indonesia' => 'Indonesian'
    }.freeze

    WGTRM_COUNTRY_MAP = {
      'Russia'              => 'Russian Federation',
      'Syria'               => 'Syrian Arab Republic',
      'Venezuela'           => 'Venezuela, Bolivarian Republic of',
      'Palestine'           => 'Palestine, State of',
      'Iran'                => 'Iran, Islamic Republic of',
      'Tanzania'            => 'Tanzania, United Republic of',
      'United States (USA)' => 'United States',
      'Kyrgyz Republic'     => 'Kyrgyzstan',
      'Macedonia'           => 'Macedonia, Republic of'
    }.freeze

    RESIDENCE_MAP = [
      %w(alingsås Alingsås),
      %w(älmhult Älmhult),
      %w(alvesta Alvesta),
      %w(älvsjö Älvsjö),
      %w(ängelholm Ängelholm),
      %w(ankarsrum Ankarsrum),
      %w(are Åre),
      %w(årsta Årsta),
      %w(askersund Askersund),
      %w(avesta Avesta),
      %w(axvall Axvall),
      %w(båstad Båstad),
      %w(billesholm Billesholm),
      %w(boden Boden),
      %w(borås Borås),
      %w(borgholm Borgholm),
      %w(borlänge Borlänge),
      %w(bro Bro),
      %w(bromma Bromma),
      %w(bromölla Bromölla),
      %w(eksjö Eksjö),
      %w(eneryda Eneryda),
      %w(enköping Enköping),
      %w(eskilstuna Eskilstuna),
      %w(eslöv Eslöv),
      %w(fagersta Fagersta),
      %w(falkenberg Falkenberg),
      %w(falun Falun),
      %w(farsta Farsta),
      %w(finspång Finspång),
      %w(flen Flen),
      %w(gävle Gävle),
      %w(gislaved Gislaved),
      %w(götborg Göteborg),
      %w(goteborg Göteborg),
      %w(göteborg Göteborg),
      %w(gothen Göteborg),
      %w(hällefors Hällefors),
      %w(halmstad Halmstad),
      %w(haparanda Haparanda),
      %w(heby Heby),
      %w(helsingborg Helsingborg),
      %w(heslsingborg Helsingborg),
      %w(höör Höör),
      %w(huddinge Huddinge),
      %w(hudiksvall Hudiksvall),
      %w(hyltebruk Hyltebruk),
      %w(jönköping Jönköping),
      %w(jordbro Jordbro),
      %w(kalmar Kalmar),
      %w(karlshamn Karlshamn),
      %w(karlskoga Karlskoga),
      %w(karlskrona Karlskrona),
      %w(karlstad Karlstad),
      %w(katrineholm Katrineholm),
      %w(kävlinge Kävlinge),
      %w(kista Kista),
      %w(kosta Kista),
      %w(kramfors Kramfors),
      %w(kristianstad Kristianstad),
      %w(kristinehamn Kristinehamn),
      %w(kungsängen Stockholm),
      %w(kungsör Kungsör),
      %w(kungssbacka Kungsbacka),
      ['laholm-knäred', 'Laholm'],
      %w(långshyttan Långshyttan),
      %w(lenhovd Lenhovda),
      %w(lenhovda Lenhovda),
      %w(lidhult Lidhult),
      %w(lidköping Lidköping),
      %w(linköping Linköping),
      %w(ljungby Ljungby),
      %w(lomma Lomma),
      %w(lönsboda Lönsboda),
      %w(ludvika Ludvika),
      %w(luleå Luleå),
      %w(lund Lund),
      %w(malmo Malmö),
      %w(malmö Malmö),
      %w(malung Malung),
      %w(marsta Märsta),
      %w(mora Mora),
      %w(munsö Munsö),
      %w(nässjo Nässjö),
      %w(nässjö Nässjö),
      ['norrbotten pajala', 'Pajala'],
      %w(norrköping Norrköping),
      %w(norrtälje Norrtälje),
      %w(nybro Nybro),
      %w(nyköping Nyköping),
      %w(örebro Örebro),
      %w(örnsköldsvik Örnsköldsvik),
      %w(oskarshamn Oskarshamn),
      %w(oxelösund Oxelösund),
      ['pite havsbad', 'Piteå'],
      %w(robertsfors Robertsfors),
      %w(ronneby Ronneby),
      %w(säffle Säffle),
      %w(saltsjöbaden Saltsjöbaden),
      %w(sandviken Sandviken),
      ['särö(near gothenburg)', 'Göteborg'],
      %w(simrishamn Simrishamn),
      %w(skärholmen Skärholmen),
      %w(skellefteå Skellefteå),
      %w(skene Skene),
      %w(skinnskatteberg Skinnskatteberg),
      %w(skokloster Skokloster),
      %w(söderhamn Söderhamn),
      %w(södertalije Södertälje),
      %w(södertälje Södertälje),
      %w(sollentuna Sollentuna),
      %w(solna Solna),
      %w(stavsnäs Stavsnäs),
      %w(stochlom Stockholm),
      %w(stockholm Stockholm),
      %w(stocklom Stockholm),
      %w(stockolm Stockholm),
      %w(stokholm Stockholm),
      %w(strängnäs Strängnäs),
      %w(sundbyberg Sundbyberg),
      %w(sundsvall Sundsvall),
      %w(sunne Sunne),
      %w(surte Surte),
      %w(svalöv Svalöv),
      %w(täby Täby),
      %w(tierp Tierp),
      %w(timrå Timrå),
      %w(torsaker Torsaker),
      %w(torsby Torsby),
      %w(trollhättan Trollhättan),
      %w(tyresö Tyresö),
      %w(uddevalla Uddevalla),
      %w(umeå Umeå),
      %w(undrum Undrum),
      ['upplands väsby', 'Upplands väsby'],
      %w(uppsala Uppsala),
      %w(uppsla Uppsla),
      %w(utansjö Utansjö),
      %w(vänasborg Vänasborg),
      %w(vänersborg Vänersborg),
      %w(varberg Varberg),
      %w(vårby Vårby),
      %w(västerås Västerås),
      %w(växjö Växjö),
      %w(vetlanda Vetlanda),
      %w(ystad Ystad)
      # Sort by length so that the more specific (dirty => clean) maps get hit first
    ].sort_by { |map| map.first.length }.reverse.freeze

    attr_reader :row

    def initialize(row_struct)
      @row = row_struct

      name_parts = @row.name.split(' ').map(&:strip)
      # Remove titles such as MD etc
      name_parts.shift if TITLES.include?(name_parts.first)

      @name = name_parts.join(' ')
    end

    delegate :name, to: :row
    delegate :email, to: :row
    delegate :level_of_study, to: :row
    delegate :study_major, to: :row
    delegate :latest_university, to: :row
    delegate :field_of_study, to: :row
    delegate :graduation_date, to: :row

    TITLES = %w(m M Md MD Mr MR mr MRS mrs Mrs).freeze

    def first_name
      @name.split(' ').first.titleize
    end

    def last_name
      @name.split(' ')[1..-1].join(' ').titleize
    end

    def residence
      return if row.residence.blank?

      search_residence = row.residence.strip.downcase
      RESIDENCE_MAP.each do |map|
        dirty_attribute, clean_attribute = map

        return clean_attribute if search_residence.include?(dirty_attribute)
      end
      nil
    end

    def phone
      row.mobile_phone
    end

    def country_of_origin
      name = row.country_of_origin
      mapped_name = WGTRM_COUNTRY_MAP.fetch(name, name)
      ISO3166::Country.translations.invert[mapped_name]
    end

    def languages
      split_column(row.languages).map do |string|
        # string = English (Able to negotiate)
        parts = string.split('(')
        language = parts.first.strip # 'English'
        level = parts.last[0..-2]    # 'Able to negotiate'

        name = LANGUAGE_NAME_MAP.fetch(language, language)
        proficiency = PROFICIENCY_MAP.fetch(level)

        LanguageProficiency.new(name, proficiency)
      end
    end

    def tags
      split_column(row.tags)
    end

    def interests
      split_column(row.functions)
    end

    private

    def split_column(column)
      return [] if column.blank?

      column.split('/').map(&:strip)
    end
  end
end
