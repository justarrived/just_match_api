# frozen_string_literal: true

class LinkedinJobsSerializer
  def self.to_xml(jobs:, locale: :sv)
    I18n.with_locale(locale) { build_xml_document(jobs) }
  end

  def self.build_xml_document(jobs)
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'

    builder.source do |source_node|
      source_node.publisherUrl('https://justarrived.se')
      source_node.publisher('Just Arrived')
      jobs.each { |job| build_job_xml(source_node, job) }
    end
    builder.target!
  end

  def self.build_job_xml(parent_node, job)
    parent_node.job do |node|
      node.company { |n| n.cdata!(job.company.name) }

      node.partnerJobId { |n| n.cdata!(job.to_param) }
      node.title { |n| n.cdata!(job.name.to_s) }
      node.description do |n|
        n.cdata!("#{job.description}\n\n#{special_linkedin_hashtag}")
      end

      node.location(job.full_street_address)
      node.city { |n| n.cdata!(job.city.to_s) }
      node.countryCode { |n| n.cdata!(job.country_code) }
      node.postalCode { |n| n.cdata!(job.zip.to_s) }

      node.applyUrl do |n|
        n.cdata!(
          FrontendRouter.draw(
            :job,
            id: job.to_param,
            utm_source: 'linkedin',
            utm_medium: 'ad',
            utm_campaign: 'welcometalent'
          )
        )
      end
    end
  end

  def self.special_linkedin_hashtag
    '#welcometalent'
  end
end
