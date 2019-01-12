# -*- ruby -*-

require 'rubygems/package_task'
require 'fileutils'
require 'rake/clean'
require 'rake/testtask'
require_relative 'lib/kramdown/converter/math_engine/mathjaxnode'

task :default => :test
Rake::TestTask.new do |test|
  test.warning = false
  test.libs << 'test'
  test.test_files = FileList['test/test_*.rb']
end

desc "Check for MathjaxNode availability"
task :test_mathjaxnode_deps do
  html = %x{echo '$$a$$' | \
            #{RbConfig.ruby} -Ilib -r kramdown-math-mathjaxnode -S kramdown --no-config-file --math-engine mathjaxnode}
  raise (<<MJC) unless $?.success?
Some requirement by the mathjax-node-cli package has not been satisfied.
Cf. the above error messages.
MJC
  raise (<<MJN) unless %r{\A<math xmlns="http://www.w3.org/\d+/Math/MathML".*</math>\Z}m === html
The MathjaxNode engine is not available. Try "npm install mathjax-node-cli".
MJN
  puts "MathjaxNode is available, and its default configuration works."
end

desc "Update kramdown MathjaxNode test reference outputs"
task update_mathjaxnode_tests: [:test_mathjaxnode_deps] do
  # Not framed in terms of rake file tasks to prevent accidental overwrites.
  Dir['test/testcases/*.text'].each do |f|
    stem = f[0..-6] # Remove .text
    ruby "-Ilib -r kramdown-math-mathjaxnode -S kramdown --config-file #{stem}.options #{f} >#{stem}.html"
  end
end

SUMMARY = 'kramdown-math-mathjaxnode uses mathjax-node to convert math elements to MathML'

PKG_FILES = FileList.new(['COPYING', 'VERSION', 'CONTRIBUTERS', 'lib/**/*.rb', 'test/**/*'])

CLOBBER << "VERSION"
file 'VERSION' do
  puts "Generating VERSION file"
  File.open('VERSION', 'w+') {|file| file.write(Kramdown::Converter::MathEngine::MathjaxNode::VERSION + "\n")}
end

CLOBBER << 'CONTRIBUTERS'
file 'CONTRIBUTERS' do
  puts "Generating CONTRIBUTERS file"
  `echo "  Count Name" > CONTRIBUTERS`
  `echo "======= ====" >> CONTRIBUTERS`
  `git log | grep ^Author: | sed 's/^Author: //' | sort | uniq -c | sort -nr >> CONTRIBUTERS`
end

spec = Gem::Specification.new do |s|
  s.name = 'kramdown-math-mathjaxnode'
  s.version = Kramdown::Converter::MathEngine::MathjaxNode::VERSION
  s.summary = SUMMARY
  s.license = 'MIT'

  s.files = PKG_FILES.to_a

  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.3'
  s.add_dependency 'kramdown', '~> 2.0'

  s.has_rdoc = true

  s.author = 'Thomas Leitner'
  s.email = 't_leitner@gmx.at'
  s.homepage = "https://github.com/kramdown/math-mathjaxnode"
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :gemspec => ['CONTRIBUTERS', 'VERSION'] do
  print "Generating Gemspec\n"
  contents = spec.to_ruby
  File.write("kramdown-math-mathjaxnode.gemspec", contents, mode: 'w+')
end
CLOBBER << 'kramdown-math-mathjaxnode.gemspec'

desc 'Release version ' + Kramdown::Converter::MathEngine::MathjaxNode::VERSION
task :release => [:clobber, :package, :publish_files]

desc "Upload the release to Rubygems"
task :publish_files => [:package] do
  sh "gem push pkg/kramdown-math-mathjaxnode-#{Kramdown::Converter::MathEngine::MathjaxNode::VERSION}.gem"
  puts 'done'
end
