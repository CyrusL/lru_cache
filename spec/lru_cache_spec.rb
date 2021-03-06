require 'lru_cache'
require 'timecop'

describe "lru cache" do
  let(:cache) { LruCache.new(2)  }

  it "allows to put object" do
    cache.put("k", "v")
    cache.get("k").should == "v"
  end

  it "overridess the value with the same key" do
    cache.put("k", "v")
    cache.put("k", "z")
    cache.get("k").should == "z"
    cache.size.should == 1
  end

  it "evicts the items if there more objects than the capacity" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.put("k3", "v3")
    cache.get("k1").should be_nil
    cache.size.should == 2
  end

  it "renews last access when a key is fetched" do
    cache.put('k1', 'v1')
    cache.put('k2', 'v2')
    cache.get('k1')
    cache.put('k3', 'v3')
    cache.get('k3').should == 'v3'
    cache.get('k1').should == 'v1'
    cache.get('k2').should be_nil
    cache.size.should == 2
  end

  it 'returns nil for key it does not know' do
    cache.put('k1', 'v1')
    cache.put('k2', 'v2')
    cache.get('k3').should be_nil
  end

  it 'allows overriding a key and evicts the right one' do
    cache.put('k1', 'v1')
    cache.put('k2', 'v2')
    cache.put('k2', 'new v2')
    cache.get('k2').should == 'new v2'
    cache.get('k1').should == 'v1'
  end

  it 'supports ttl' do
    now = Time.now
    cache.put('k1', 'v1', 2)
    cache.get('k1').should == 'v1'
    Timecop.travel(now + 3) do
      cache.get('k1').should be_nil
    end
    cache.size.should == 0
  end
end
