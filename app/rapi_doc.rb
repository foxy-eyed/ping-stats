# frozen_string_literal: true

module PingStats
  class RapiDoc
    def call(env)
      doc_url = URI::HTTP.build(host: env["SERVER_NAME"],
                                port: env["SERVER_PORT"],
                                path: "/#{PingStats::API.prefix}/#{PingStats::API.version}/doc").to_s

      [200, { "Content-Type" => "text/html" }, [build_body(doc_url)]]
    end

    private

    def build_body(swagger_doc_url)
      <<~HTML
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8">
          <script type="module" src="https://unpkg.com/rapidoc/dist/rapidoc-min.js"></script>
        </head>
        <body>
          <rapi-doc spec-url="#{swagger_doc_url}" theme="dark"></rapi-doc>
        </body>
        </html>
      HTML
    end
  end
end
