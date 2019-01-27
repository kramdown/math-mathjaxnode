**Important: This repo and gem are unmaintained! If you are interested in
maintaining, please contact me at <t_leitner@gmx.at>.**

# kramdown math engine for conversion to MathML

This is a converter for [kramdown](https://kramdown.gettalong.org) that uses
[Mathjax-Node](https://github.com/mathjax/MathJax-node) to convert math
formulas to MathML.

Note: Until kramdown version 2.0.0 this math engine was part of the kramdown
distribution.


## Installation

~~~ruby
gem install kramdown-math-mathjaxnode
~~~


## Usage

~~~ruby
require 'kramdown'
require 'kramdown-math-mathjaxnode

Kramdown::Document.new(text, math_engine: :mathjaxnode).to_html
~~~


## Documentation

To use Mathjax-Node, set the option `math_engine` to 'mathjaxnode' and make sure that both
[Node.js](https://nodejs.org/) and Mathjax-Node are available. The Mathjax-Node library can be
installed, e.g., via npm by running `npm install -g mathjax-node`. Instructions for installing
Node.js can be found in the [joyent/node wiki](https://github.com/joyent/node/wiki/Installation).

The Mathjax-Node engine supports the following keys of the option `math_engine_opts`:

* semantics:

  Specifies whether TeX code should be added in a `<semantics>` tag. It defaults to `false` but if
  set to `true`, a `<semantics>` tag with the LaTeX code itself is added.

* texhints:

  Specifies whether TeX-specific classes should be added. It defaults to `true` but if set to
  `false`, the TeX-specific classes, like `MJX-TeXAtom-ORD`, will not be added. These classes
  provide styling hints to the MathJax browser library.


## Development

Clone the git repository and you are good to go. You probably want to install
`rake` so that you can use the provided rake tasks.


## License

MIT - see the **COPYING** file.
