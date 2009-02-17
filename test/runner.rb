#! /usr/bin/ruby
#
# Info:: Pjotr's shared Ruby modules
# Author:: Pjotr Prins
# mail:: pjotr.public05@thebird.nl
# Copyright:: October 2008
# License:: Ruby License

$stderr.print "Use --help switch for options\n"
$testpath = File.dirname(__FILE__)
$: << $testpath << $testpath+'/../lib' << $testpath+'/../lib/ruby'
$rtestpath = $testpath+'/regression'

require 'optparse'
require 'ostruct'

require 'test/unit'

$UNITTEST = true

require 'control/wikitexer'
require 'input/wtparser'
require 'doc/titlenumbering'
require 'doc/environment/environmentstack'
require 'input/tex/functions'
require 'input/wikimedia/urlformatting'
