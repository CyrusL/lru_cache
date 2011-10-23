require "lru_cache"
describe "lru cache" do
  
  let(:cache) { LruCache.new(2)  }
  
  it "should allow to put object" do
    cache.put("k", "v")
    cache.get("k").should == "v"
  end

  it "should override the value with the same key" do
    cache.put("k", "v")
    cache.put("k", "z")
    cache.get("k").should == "z"
  end

  it "should evicts the items if there more objects than the capacity" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.put("k3", "v3")
    cache.get("k1").should be_nil
  end

  it "should renew last access when a key is fetch" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.get("k1")
    cache.put("k3", "v3")
    cache.get("k2").should be_nil
  end

  it "should return value that just added" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.get("k1")
    cache.put("k3", "v3")
    cache.get("k3").should == "v3"
  end

end
