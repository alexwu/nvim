; extends

(recipe_body
  (shebang
    (language) @_lang) @_bang
  (#any-of? @_bang "#!/usr/bin/env rails runner" "#!/usr/bin/env rails r")
  (#set! injection.language "ruby")
  (#set! injection.include-children)) @injection.content

(recipe_body
  (shebang
    (language) @_lang) @_bang
  (#any-of? @_lang "parallel")
  (#set! injection.language "bash")
  (#set! injection.include-children)) @injection.content
