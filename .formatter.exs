# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 140,
  import_deps: [:placebo],
  locals_without_parens: [plug: 2]
]
