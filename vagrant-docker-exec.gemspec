# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-docker-exec/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-docker-exec"
  spec.version       = VagrantPlugins::DockerExec::VERSION
  spec.authors       = ["William Kolean"]
  spec.email         = ["william.kolean@gmail.com"]
  spec.summary       = %q{docker-exec runs a new command in a running container.}
  spec.description   = %q{Vagrant plugin adding the command docker-exec [options] container -- [command] which invokes `docker exec` to run a command in a running container.}
  spec.homepage      = "https://github.com/wkolean/vagrant-docker-exec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 12.3.3"
end
