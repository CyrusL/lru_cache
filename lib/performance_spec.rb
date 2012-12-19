require 'lru_cache'
require 'timecop'

describe "lru cache load test" do
  let(:cache) { LruCache.new(2) }

  def rand_string
    (0...8).map{65.+(rand(26)).chr}.join
  end

  it "does not have memory leak" do
    10.times do
      cache.put(rand_string, "9")
    end
    debugger
    sleep(5)
    GC.start
    ObjectSpace.each_object(LruCache::Node){}.should == 2
  end
end
