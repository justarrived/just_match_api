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
      jobs.each { |job| build_job_xml(source_node, Linkedin::JobWrapper.new(job: job)) }
    end
    builder.target!
  end

  def self.build_job_xml(parent_node, job)
    parent_node.job do |node|
      node.company { |n| n.cdata!(job.company_name) }

      node.partnerJobId { |n| n.cdata!(job.partner_job_id) }
      node.title { |n| n.cdata!(job.title) }
      node.description { |n| n.cdata!(job.description) }

      node.location(job.location)
      node.city { |n| n.cdata!(job.city) }
      node.countryCode { |n| n.cdata!(job.country_code) }
      node.postalCode { |n| n.cdata!(job.postal_code) }

      node.applyUrl { |n| n.cdata!(job.apply_url) }
    end
  end

  def self.special_linkedin_hashtag
    '#welcometalent'
  end
end
