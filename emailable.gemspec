Gem::Specification.new do |s|
  s.name        = 'emailable'
  s.version     = '0.0.0'
  s.date        = '2013-08-15'
  s.summary     = "Allow any Ruby object to specify it's contacts."
  s.description = "Provides a standard way to specify to, cc, bcc 
                   fields for emails which can be used by ActionMailer."
  s.authors     = ["Aaron C. Wieberg"]
  s.email       = "wiebergac@missouri.edu"
  s.homepage    = 'http://projects.orcs.missouri.edu'
  s.license     = 'MIT'
  s.add_development_dependency "rspec"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
