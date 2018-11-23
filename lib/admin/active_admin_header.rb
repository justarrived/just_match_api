# frozen_string_literal: true

module Admin
  class ActiveAdminHeader
    def self.to_s
      return unless AppConfig.admin_google_analytics_active?

      # rubocop:disable Rails/OutputSafety
      <<-HTML.html_safe
        <script type="text/javascript">
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

          ga('create', '#{AppConfig.admin_google_analytics_tracking_id}', 'auto');
          ga('send', 'pageview');
        </script>
      HTML
      # rubocop:enable Rails/OutputSafety
    end
  end
end
