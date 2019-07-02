
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sourcedocs/version"

Gem::Specification.new do |spec|
  spec.name          = "sourcedocs"
  spec.version       = Sourcedocs::VERSION
  spec.authors       = ["AF_pfo"]
  spec.email         = ["paul.forstner@appsfactory.de"]

  spec.summary       = "Creates Markdown files from swift code"
  spec.description   = "Must be running in your Xcode project's root directory"
  spec.homepage      = "https://github.com/forstnerpaul/SourceDocs"
  
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = `git ls-files`.split($/)
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = "sourcedocs"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
