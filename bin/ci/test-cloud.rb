#!/usr/bin/env ruby

require "luffa"
require "bundler"
require "run_loop"

# Only maintainers can submit XTC tests.
if Luffa::Environment.travis_ci? && !ENV["TRAVIS_SECURE_ENV_VARS"]
  Luffa.log_info("Skipping XTC submission; non-maintainer activity")
  exit 0
end

device_set = ENV["XTC_DEVICE_SET"]

if !device_set || device_set == ""
  device_set = ARGV[0]
end

if !device_set || device_set == ""
  device_set = ["890e6a17", "f254524b", "f6b33ead", "2c635bdb"].sample
end

Luffa.unix_command("bin/ci/make-ipa.sh")
Dir.chdir("CalWebViewApp") do
  Bundler.with_clean_env do
    Luffa.unix_command("bundle update")
    Luffa.unix_command("bundle exec briar xtc #{device_set}")
  end
end

