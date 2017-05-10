# frozen_string_literal: true

class BlocketjobbJobsSerializer
  def self.to_xml(jobs:)
    I18n.with_locale(:en) do
      build_xml_document(jobs)
    end
  end

  def self.build_xml_document(jobs)
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'

    builder.jobfeed_xml_stucture do |node|
      node.ads do |ads_node|
        jobs.each { |job| build_ad_xml(ads_node, BlocketjobbJobPresenter.new(job)) }
      end
    end
    builder.target!
  end

  def self.build_ad_xml(parent_node, job_view)
    parent_node.ad do |node|
      node.external_ad_id { |n| n.cdata!(job_view.external_ad_id) }
      node.display_at { |n| n.cdata!(job_view.display_at) }
      node.category(cgID: job_view.category)
      node.subject { |n| n.cdata!(job_view.subject) }
      node.body { |n| n.cdata!(job_view.body) }
      node.job_ad_type { |n| n.cdata!(job_view.job_ad_type) }
      node.employment { |n| n.cdata!(job_view.employment) }
      node.apply_date { |n| n.cdata!(job_view.apply_date) }
      node.region { |n| n.cdata!(job_view.region) }
      node.region_name { |n| n.cdata!(job_view.region_name) }
      node.municipality { |n| n.cdata!(job_view.municipality) }
      node.address { |n| n.cdata!(job_view.address) }
      node.zipcode { |n| n.cdata!(job_view.zipcode) }
      node.corp_name { |n| n.cdata!(job_view.company_name) }
      node.corp_orgno { |n| n.cdata!(job_view.company_orgno) }
      node.corp_descr { |n| n.cdata!(job_view.company_description) }
      node.corp_url { |n| n.cdata!(job_view.company_url) }
      node.image do |image_node|
        image_node.customerLogo do |logo_node|
          logo_node.url { |n| n.cdata!(job_view.company_logo_url) }
        end
      end
      node.apply_url { |n| n.cdata!(job_view.apply_url) }
      node.pub_date { |n| n.cdata!(job_view.publication_date) }
      node.update_date { |n| n.cdata!(job_view.update_date) }
      node.end_date { |n| n.cdata!(job_view.end_date) }
      node.provider_name { |n| n.cdata!(job_view.provider_name) }
    end
  end
end
