# frozen_string_literal: true

module Admin
  class ActiveAdminHeader < ActiveAdmin::Views::Header
    def build(namespace, menu)
      super(namespace, menu)

      script(type: 'text/javascript') { ga_script } if ga_tracking_active?
    end

    def ga_script
      @ga_script ||= begin
        # rubocop:disable Rails/OutputSafety
        <<-HTML.html_safe
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

          ga('create', '#{ga_tracking_id}', 'auto');
          ga('send', 'pageview');
        HTML
        # rubocop:enable Rails/OutputSafety
      end
    end

    def ga_tracking_active?
      AppConfig.admin_google_analytics_active?
    end

    def ga_tracking_id
      AppConfig.admin_google_analytics_tracking_id
    end
  end
end
