class LruCache

  def initialize(capacity=2)
    @items = Hash.new
    @capacity = capacity
    @head = nil
    @tail = nil
  end

  def put(k,v)
    if @items.size == @capacity
      evict_last_recent_used_item
    end
    node = Node.new(k, v, @tail, nil)
    @head = node if @head.nil?
    @tail.next_node = node if @tail
    @tail = node
    @items[k] = node
  end

  def get(k)
    node = @items[k]
    return nil unless node
    node.prev_node.next_node = node.next_node if node.prev_node
    node.next_node.prev_node = node.prev_node if node.next_node
    @head = node.next_node if @head == node
    node.next_node = nil
    @tail.next_node = node
    node.prev_node = @tail
    @tail = node
    @items[k].value
  end

  private
  def evict_last_recent_used_item
    @items[@head.key] = nil
    @head = @head.next_node
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

