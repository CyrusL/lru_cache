class LruCache
  def initialize(capacity)
    @items    = Hash.new
    @capacity = capacity
    @lru_list = DoubleLinkedList.new
  end

  def put(k,v)
    if @items.size == @capacity
      evist_last_recently_used
    end
    node = @lru_list.add(k, v)
    @items[k] = node
  end

  def get(k)
    node = @items[k]
    return nil unless node
    @lru_list.change_mru(node)
    node.data
  end

  private
  def evist_last_recently_used
    @items[@lru_list.lru.key] = nil
    @lru_list.remove_lru
  end

  class DoubleLinkedList
    attr_accessor :lru, :mru

    def initialize
      @lru = nil
      @mru = nil
    end

    def change_mru(node)
      remove_node(node)
      add(node.key, node.data)
    end

    def add(k, v)
      node = Node.new(k, v, @mru, nil)
      @lru = node unless lru
      @mru.older = node if mru
      @mru = node
    end

    def remove_lru
      remove_node(lru)
    end

    private
    def remove_node(node)
      node.newer.older = node.older if node.newer
      node.older.newer = node.newer if node.older
      @lru = node.older if @lru == node
    end
  end

  class Node
    attr_accessor :older, :newer, :data, :key

    def initialize(key, data, older, newer)
      @key  = key
      @data = data
      @older = older
      @newer = newer
    end
  end
end

