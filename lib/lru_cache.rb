class LruCache
  def initialize(capacity)
    @items    = Hash.new
    @capacity = capacity
    @lru_list = DoubleLinkedList.new
  end

  def size
    @items.size
  end

  def items
    @items
  end

  def put(k,v, ttl=nil)
    remove_key_if_present(k)
    if @items.size >= @capacity
      evist_last_recently_used
    end
    expired_at = ttl ?  Time.now + ttl : nil
    @items[k] = @lru_list.add(k, v, expired_at)
  end

  def get(k)
    node = @items[k]
    return nil unless node
    if node.expired?
      remove_key_if_present(k)
      return nil
    end
    @lru_list.change_mru(node)
    @items[k] = @lru_list.mru
    return node.data
  end

  private
  def evist_last_recently_used
    @lru_list.remove_node @items.delete(@lru_list.lru.key)
  end

  def remove_key_if_present(k)
    if existing_node = @items[k]
      @lru_list.remove_node(existing_node)
      @items.delete(k)
    end
  end

  class DoubleLinkedList
    attr_accessor :lru, :mru

    def initialize
      @lru = nil
      @mru = nil
    end

    def change_mru(node)
      remove_node(node)
      add(node.key, node.data, node.expired_at)
    end

    def add(k, v, expired_at)
      node = Node.new(k, v, @mru, nil, expired_at)
      set_lru(node) unless lru
      @mru.newer = node if mru
      @mru = node
    end

    def remove_node(node)
      node.newer.older = node.older if node.newer
      node.older.newer = node.newer if node.older
      set_lru(node.newer) if @lru == node
    end

    def set_lru(node)
      @lru = node
    end
  end

  class Node
    attr_accessor :older, :newer, :data, :key, :expired_at

    def initialize(key, data, older, newer, expired_at)
      @key  = key
      @data = data
      @older = older
      @newer = newer
      @expired_at = expired_at
    end

    def expired?
      @expired_at && Time.now >= @expired_at
    end

    def inspect
      "Node #{key}"
    end
  end
end

