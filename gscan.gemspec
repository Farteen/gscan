
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gscan/version"

Gem::Specification.new do |spec|
  spec.name          = "gscan"
  spec.version       = Gscan::VERSION
  spec.authors       = ["Xu Jiawei"]
  spec.email         = ["jiawei.xu@centrixlink.com"]

  spec.summary       = %q{Learning scan: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{Learning scan: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/Farteen/gscan"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency('slack-notifier', '>= 2.0.0', '< 3.0.0') # Slack notifications
  spec.add_dependency('xcodeproj', '>= 1.5.7', '< 2.0.0') # Needed for commit_version_bump action and gym code_signing_mapping
  spec.add_dependency('xcpretty', '~> 0.2.8') # prettify xcodebuild output
  spec.add_dependency('terminal-notifier', '>= 1.6.2', '< 2.0.0') # macOS notifications
  spec.add_dependency('terminal-table', '>= 1.4.5', '< 2.0.0') # Actions documentation
  spec.add_dependency('plist', '>= 3.1.0', '< 4.0.0') # Needed for set_build_number_repository and get_info_plist_value actions
  spec.add_dependency('CFPropertyList', '>= 2.3', '< 4.0.0') # Needed to be able to read binary plist format
  spec.add_dependency('addressable', '>= 2.3', '< 3.0.0') # Support for URI templates
  spec.add_dependency('multipart-post', '~> 2.0.0') # Needed for uploading builds to appetize
  spec.add_dependency('word_wrap', '~> 1.0.0') # to add line breaks for tables with long strings

  spec.add_dependency('public_suffix', '~> 2.0.0') # https://github.com/fastlane/fastlane/issues/10162

  # TTY dependencies
  spec.add_dependency('tty-screen', '>= 0.6.3', '< 1.0.0') # detect the terminal width
  spec.add_dependency('tty-spinner', '>= 0.8.0', '< 1.0.0') # loading indicators

  spec.add_dependency('babosa', '>= 1.0.2', "< 2.0.0")
  spec.add_dependency('colored') # colored terminal output
  spec.add_dependency('commander-fastlane', '>= 4.4.6', '< 5.0.0') # CLI parser
  spec.add_dependency('excon', '>= 0.45.0', '< 1.0.0') # Great HTTP Client
  spec.add_dependency('faraday-cookie_jar', '~> 0.0.6')
  spec.add_dependency('fastimage', '>= 2.1.0', '< 3.0.0') # fetch the image sizes from the screenshots
  spec.add_dependency('gh_inspector', '>= 1.1.2', '< 2.0.0') # search for issues on GitHub when something goes wrong
  spec.add_dependency('highline', '>= 1.7.2', '< 2.0.0') # user inputs (e.g. passwords)
  spec.add_dependency('json', '< 3.0.0') # Because sometimes it's just not installed
  spec.add_dependency('mini_magick', '~> 4.5.1') # To open, edit and export PSD files
  spec.add_dependency('multi_json') # Because sometimes it's just not installed
  spec.add_dependency('multi_xml', '~> 0.5')
  spec.add_dependency('rubyzip', '>= 1.2.1', '< 2.0.0') # fix swift/ipa in gym
  spec.add_dependency('security', '= 0.1.3') # macOS Keychain manager, a dead project, no updates expected
  spec.add_dependency('xcpretty-travis-formatter', '>= 0.0.3')
  spec.add_dependency('dotenv', '>= 2.1.1', '< 3.0.0')
  spec.add_dependency('bundler', '>= 1.12.0', '< 2.0.0') # Used for fastlane plugins
  spec.add_dependency('faraday', '~> 0.9') # Used for deploygate, hockey and testfairy actions
  spec.add_dependency('faraday_middleware', '~> 0.9') # same as faraday
  spec.add_dependency('simctl', '~> 1.6.3') # Used for querying and interacting with iOS simulators

  # The Google API Client gem is *not* API stable between minor versions - hence the specific version locking here.
  # If you upgrade this gem, make sure to upgrade the users of it as well.
  spec.add_dependency('google-api-client', '>= 0.21.2', '< 0.24.0') # Google API Client to access Play Publishing API

  spec.add_dependency('emoji_regex', '~> 0.1') # Used to scan for Emoji in the changelog

  # Development only
  spec.add_development_dependency('rake', '< 12')
  spec.add_development_dependency('rspec', '~> 3.5.0')
  spec.add_development_dependency('rspec_junit_formatter', '~> 0.2.3')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('pry-byebug')
  spec.add_development_dependency('pry-rescue')
  spec.add_development_dependency('pry-stack_explorer')
  spec.add_development_dependency('yard', '~> 0.9.11')
  spec.add_development_dependency('webmock', '~> 2.3.2')
  spec.add_development_dependency('coveralls', '~> 0.8.13')
  spec.add_development_dependency('rubocop', Fastlane::RUBOCOP_REQUIREMENT)
  spec.add_development_dependency('rubocop-require_tools', '>= 0.1.2')
  spec.add_development_dependency('rb-readline') # https://github.com/deivid-rodriguez/byebug/issues/289#issuecomment-251383465
  spec.add_development_dependency('rest-client', '>= 1.8.0')
  spec.add_development_dependency('fakefs', '~> 0.8.1')
  spec.add_development_dependency('sinatra', '~> 1.4.8')
  spec.add_development_dependency('xcov', '~> 1.4.1') # Used for xcov's parameters generation: https://github.com/fastlane/fastlane/pull/12416
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fastlane_core", "~>1.0"
end
