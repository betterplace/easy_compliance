require_relative 'lib/easy_compliance/version'

Gem::Specification.new do |spec|
  spec.name          = 'easy_compliance'
  spec.version       = EasyCompliance::VERSION
  spec.authors       = ['betterplace development team']
  spec.email         = ['developers@betterplace.org']

  spec.summary       = 'Ruby toolkit for https://www.easycompliance.de'
  spec.homepage      = 'https://github.com/betterplace/easy_compliance'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'excon'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
