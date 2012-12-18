$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new "lru_cache", '0.1' do |s|
  s.authors     = ["Phan Le"]
  s.email       = ["phan.anh.le@gmail.com"]
  s.homepage    = "http://phanle.github.com/lru_cache"
  s.summary     = %q{LRU cache}
  s.description = %Q{#{s.summary}}
  s.require_path= ["lib"] 
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
end
