require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'rake/rdoctask'

GEM = "mikyung"
GEM_VERSION = "0.8.0"
SUMMARY  = "Mikyung is a restful client built on top of Restfulie that allows real rest clients to be built."
AUTHOR   = "Guilherme Silveira"
EMAIL    = "guilherme.silveira@caelum.com.br"
HOMEPAGE = "http://restfulie.caelumobjects.com"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*'].to_a
  s.add_dependency("restfulie", [">= 0.8.0"])

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::RDocTask.new("rdoc") do |rdoc|
   rdoc.options << '--line-numbers' << '--inline-source'
#   rdoc.rdoc_files.include('lib/**/**/*.rb')
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/restfulie/**/*.rb', 'README.textile']   # optional
    # t.options = ['--any', '--extra', '--opts'] # optional
  end
rescue; end

desc "Install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{GEM}-#{GEM_VERSION} -l}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Builds the project"
task :build => :install

desc "Default build will run specs"
task :default => :install

