Gem::Specification.new do |s|
  s.name        = 'deep_cloning'
  s.version     = '2.0.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jan De Poorter"]
  s.email       = 'jan@sumocoders.be'
  s.summary     = "Easily duplicate ActiveRecord objects"
  s.description = "Allows you to dup an ActiveRecord object with selectively keeping attributes / associations with :include, :exclude, ..."
  s.files       = Dir.glob('lib/**/*') + %w(MIT-LICENSE README.rdoc)
  s.homepage    = 'https://github.com/defv/deep_cloning'
end
