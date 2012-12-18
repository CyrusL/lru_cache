class LruCache
  def initialize(capacity)
    @items    = Hash.new
    @capacity = capacity
    @lru_list = DoubleLinkedList.new
  end

  def put(k,v, ttl=nil)
    remove_key_if_present(k)
    if @items.size == @capacity
      evist_last_recently_used
    end
    expired_at = ttl ?  Time.now + ttl : nil
    new_node = @lru_list.add(k, v, expired_at)
    @items[k] = new_node
  end

  def get(k)
    node = @items[k]
    return nil unless node
    if node.expired?
      remove_key_if_present(k)
      return nil
    end
    @lru_list.change_mru(node)
    return node.data
  end

  private
  def evist_last_recently_used
    @items[@lru_list.lru.key] = nil
    @lru_list.remove_lru
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
      @lru = node unless lru
      @mru.older = node if mru
      @mru = node
    end

    def remove_lru
      remove_node(lru)
    end

    def remove_node(node)
      node.newer.older = node.older if node.newer
      node.older.newer = node.newer if node.older
      @lru = node.older if @lru == node
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
      return false unless @expired_at
      return Time.now >= @expired_at
    end
  end
end

