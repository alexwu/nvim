; extends

; (call
;   method: (identifier) @sig.method
;   block: (block) @sig.body
;   (#eq? @sig.method "sig")
;   (#set! conceal "...")
; ) @sig
;
(call
  method: (identifier) @type.definition
  (#eq? @type.definition "sig")) @type
