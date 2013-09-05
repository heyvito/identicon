lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
	s.name					= "identicon"
	s.version				= "0.0.2"
	s.authors				= ["Victor Gama"]
	s.email					= ["victor@insitelabs.com.br"]

	s.description		= "A simple github-like identicons generator."
	s.summary			= "A simple github-like identicons generator."
	s.homepage			= "http://github.com/victorgama/identicon"
	s.license			= "MIT"

	s.files				= `git ls-files`.split($/)
	s.executables		= s.files.grep(%r{^bin/}) { |file| File.basename(file) }
	s.require_paths		= ["lib"]

	s.add_dependency	"chunky_png", "~> 1.2.8"
end