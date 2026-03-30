Gem::Specification.new do |s|
  s.name        = 'ae'
  s.version     = '1.9.0'
  s.summary     = 'Assertive Expressive'
  s.description = 'Assertive Expressive is an assertions library specifically designed ' \
                  'for reuse by other test frameworks.'

  s.authors     = ['Trans']
  s.email       = ['transfire@gmail.com']

  s.homepage    = 'https://github.com/rubyworks/ae'
  s.license     = 'BSD-2-Clause'

  s.required_ruby_version = '>= 3.1'

  s.files       = Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'HISTORY.md', 'NOTICE.md', 'demo/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'ansi'

  s.add_development_dependency 'rake', '>= 13'
  s.add_development_dependency 'qed', '>= 2.9'
end
