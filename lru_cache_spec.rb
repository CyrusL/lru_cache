require "lru_cache"
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
  end

  it "evicts the items if there more objects than the capacity" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.put("k3", "v3")
    cache.get("k1").should be_nil
  end

  it "renews last access when a key is fetched" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.get("k1")
    cache.put("k3", "v3")
    cache.get("k2").should be_nil
  end

  it "returns value that just added" do
    cache.put("k1", "v1")
    cache.put("k2", "v2")
    cache.get("k1")
    cache.put("k3", "v3")
    cache.get("k3").should == "v3"
  end
end
