#!/usr/bin/env ruby
# coding: utf-8

require 'bibtex'     # bibtex-ruby
require 'citeproc'   # citeproc-ruby
require 'csl/styles' # csl-styles

if ARGV.empty?
  puts "Usage: $0 <bibtex file>"
  exit 1
end

SUBS = {
  "{\\'a}" => "á",
  "{\\'e}" => "é",
  "{\\'i}" => "í",
  "{\\'o}" => "ó",
  "{\\'u}" => "ú",
  '{\\"a}' => "ä",
  '{\\"e}' => "ë",
  '{\\"i}' => "ï",
  '{\\"o}' => "ö",
  '{\\"u}' => "ü",
  "{\\l}" => "ł",
  "{\\L}" => "Ł",
  /\{?\\Textregistered\}?/ => "®",
}

def to_citation filename
  # style processor
  cp = CiteProc::Processor.new style: 'apa', format: 'text'
  # read bibtex
  b = BibTeX.open(filename).to_citeproc
  # sort in alphabetical order
  b.sort_by! { |i| i["author"][0]["family"] }
  # import to processor
  cp.import b
  # render each element
  elements = b.map { |i| i["id"] }.map { |i| cp.render(:bibliography, id: i)[0] }.join "\n"
  SUBS.each_pair { |k,v| elements.gsub!(k, v) }
  elements
end

ARGV.each { |f| puts to_citation(f) }
