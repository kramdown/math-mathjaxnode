# -*- coding: utf-8; frozen_string_literal: true -*-
#
#--
# Copyright (C) 2019 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown-math-mathjaxnode which is licensed under the MIT.
#++
#

require 'kramdown/converter'

module Kramdown::Converter #:nodoc:
  module MathEngine #:nodoc

    # Uses the mathjax-node-cli library for converting math formulas to MathML.
    module MathjaxNode

      VERSION = '1.0.0'

      # MathjaxNode is available if this constant is +true+.
      AVAILABLE = begin
        %x{node --version}[1..-2] >= '4.5'
      rescue
        begin
          %x{nodejs --version}[1..-2] >= '4.5'
        rescue
          false
        end
      end && begin
        npm = %x{npm --global --depth=1 list mathjax-node-cli 2>&1}

        unless /mathjax-node-cli@/ === npm.lines.drop(1).join("\n")
          npm = %x{npm --depth=1 list mathjax-node-cli 2>&1}
        end

        T2MPATH = File.join(npm.lines.first.strip, "node_modules/mathjax-node-cli/bin/tex2mml")
        /mathjax-node-cli@/ === npm.lines.drop(1).join("\n") && File.exist?(T2MPATH)
      rescue
        false
      end

      unless AVAILABLE
        raise "Needed dependencies (node, mathjax-node-cli) not found"
      end

      def self.call(converter, el, opts)
        type = el.options[:category]

        cmd = [T2MPATH]
        cmd << "--inline" unless type == :block
        cmd << "--semantics" if converter.options[:math_engine_opts][:semantics] == true
        cmd << "--notexhints" if converter.options[:math_engine_opts][:texhints] == false
        result = IO.popen(cmd << el.value).read.strip

        attr = el.attr.dup
        attr.delete('xmlns')
        attr.delete('display')
        result.insert("<math".length, converter.html_attributes(attr))

        (type == :block ? "#{' '*opts[:indent]}#{result}\n" : result)
      end

    end

  end

  add_math_engine(:mathjaxnode, MathEngine::MathjaxNode)

end
