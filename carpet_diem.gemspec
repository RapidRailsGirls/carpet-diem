Gem::Specification.new do |s|
  s.name        = 'carpet_diem'
  s.version     = '0.0.6'
  s.licenses    = ['MIT']
  s.summary     = "A Gosu game about a flying carpet"
  s.description = "Be a flying carpet that hovers through the clouds. On your way up you will encounter magic lamps. Rub them to see if a good or an evil genie is hidden inside, the one adding points to your score, the other being your worst enemy!"
  s.authors     = ['Brigitte Markmann', 'Kathi Zwick']
  s.email       = ['bri.ma@gmx.de', 'ka.zwick@gmail.com']
  s.files       = %w(carpet_diem.gemspec)
  s.files      += Dir.glob('lib/**/*') + Dir.glob('bin/**/*.rb')
  s.homepage    = 'https://github.com/RapidRailsGirls/carpet-diem'
  s.executables = %w[carpet_diem]
  s.add_runtime_dependency 'gosu', '0.7.50'

  s.add_development_dependency 'rspec'

  s.required_ruby_version = '>= 1.9.3'

end