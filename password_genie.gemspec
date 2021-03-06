
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "password_genie/version"

Gem::Specification.new do |spec|
  spec.name          = "password_genie"
  spec.version       = PasswordGenie::VERSION
  spec.authors       = ["mepyyeti"]
  spec.email         = ["rcabej@gmail.com"]
  
  spec.summary       = %q{minor bug fixes and bundle migration. "exe" to "bin" modification.}
  spec.description   = %q{a simple tool to build a password/pin number sqlite repository based on user defined parameters 2. archive passwords/pin numbers, usernames, and corresponding site data 3. and search data. requires sqlite3. minor big fixes and bundle migration.}
  spec.homepage      = "https://www.github.com/mepyyeti/password_genie"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  #spec.bindir        = "exe"
  spec.executables   = ["password_genie"]#spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0", ">= 10.5.0"
  spec.add_runtime_dependency "sqlite3", "~> 1.4.0", ">= 1.4.0"
  spec.post_install_message = "thx.  https://www.github.com/mepyyeti/password_genie"
end
