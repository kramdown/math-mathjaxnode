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


## Development

Clone the git repository and you are good to go. You probably want to install
`rake` so that you can use the provided rake tasks.


## License

MIT - see the **COPYING** file.
