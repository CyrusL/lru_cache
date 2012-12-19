require 'lru_cache'
require 'timecop'

describe "lru cache load test" do
  let(:cache) { LruCache.new(2) }

  class CachedValue; end

  it "does not have memory leak" do
    10.times do |i|
      cache.put(i, CachedValue.new)
    end

    10.times do |i|
      cache.get(i)
    end

    expect { GC.start }.to change{ ObjectSpace.each_object(CachedValue){} }
  end
end
