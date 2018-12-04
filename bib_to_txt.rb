#!/usr/bin/env ruby

require 'bibtex'     # bibtex-ruby
require 'citeproc'   # citeproc-ruby
require 'csl/styles' # csl-styles

if ARGV.empty?
  puts "Usage: $0 <bibtex file>"
  exit 1
end

# style processor
cp = CiteProc::Processor.new style: 'apa', format: 'text'
# read bibtex
b = BibTeX.open(ARGV[0]).to_citeproc
# sort in alphabetical order
b.sort_by! { |i| i["author"][0]["family"] }
# import to processor
cp.import b
# render each element
b.map { |i| i["id"] }.each { |i| puts cp.render :bibliography, id: i }

