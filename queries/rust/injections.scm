;; extends
((identifier) @ruby_macro(token_tree
    (string_literal) @injection.content
    (#offset! @injection.content 0 1 0 -1))
  (#eq? @ruby_macro "ruby")
  (#set! injection.language "ruby"))
