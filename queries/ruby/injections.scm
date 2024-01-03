;; extends
(heredoc_body
  (heredoc_content) @injection.content
  (heredoc_end) @identifier
  (#any-of? @identifier "ERB")
  (#set! injection.language "embedded_template"))
