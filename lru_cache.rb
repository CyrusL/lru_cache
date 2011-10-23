class LruCache

  def initialize(capacity=2)
    @items = Hash.new
    @capacity = capacity
    @lru_list = DoubleLinkedList.new
  end

  def put(k,v)
    if @items.size == @capacity
      evict_last_recent_used_item
    end
    node = @lru_list.add_node(k, v)
    @items[k] = node
  end

  def get(k)
    node = @items[k]
    return nil unless node
    @lru_list.remove_node(node)
    @lru_list.add_node(node.key, node.value)
    node.value
  end

  private
  def evict_last_recent_used_item
    @items[@lru_list.head.key] = nil
    @lru_list.remove_head
  end

  class DoubleLinkedList
    attr_accessor :head, :tail

    def initialize
      @head = nil
      @tail = nil
    end

    def add_node(k, v)
      node = Node.new(k, v, @tail, nil)
      @head = node unless @head
      @tail.next_node = node if @tail
      @tail = node
      return node
    end

    def remove_node(node)
      node.prev_node.next_node = node.next_node if node.prev_node
      node.next_node.prev_node = node.prev_node if node.next_node
      @head = node.next_node if @head == node
    end

    def remove_head
      remove_node(head)
    end

  end

  class Node
    attr_accessor :next_node, :prev_node, :value, :key

    def initialize(key, data, next_node, prev_node)
      @key = key
      @value = data
      @next_node = next_node
      @prev_node = prev_node
    end

  end

end

