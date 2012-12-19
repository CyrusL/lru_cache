require 'lru_cache'
require 'timecop'

describe "lru cache load test" do
  let(:cache) { LruCache.new(2) }

  class CachedValue; end

  class CacheKey; end

  it "does not have memory leak" do
    10.times do
      cache.put(CacheKey.new, CachedValue.new)
    end
    expect { GC.start }.to change{ ObjectSpace.each_object(CachedValue){} }
  end
end
