class DoubleLinkedList
  attr_accessor :tail, :head

  def initialize
    @tail = nil
    @head = nil
  end

  def promote_to_head(node)
    return node if head == node
    remove_node(node)
    node.left = head
    set_head(node)
  end

  def add(k, v, expired_at)
    node = Node.new(k, v, @head, nil, expired_at)
    set_head(node)
  end

  def remove_node(node)
    node.right.left = node.left if node.right
    node.left.right = node.right if node.left
    set_tail(node.right) if @tail == node
    @head = node.left    if @head == node
    node.left, node.right = nil, nil
  end

  def size
    size = 0
    current = head
    while current
      size += 1
      current = current.left
    end
    size
  end

  def set_tail(node)
    @tail = node
  end

  private
  def set_head(new_head)
    set_tail(new_head) unless tail
    @head.right = new_head if head
    @head = new_head
  end

  class Node
    attr_accessor :left, :right, :data, :key, :expired_at

    def initialize(key, data, left, right, expired_at)
      @key  = key
      @data = data
      @left = left
      @right = right
      @expired_at = expired_at
    end

    def expired?
      @expired_at && Time.now >= @expired_at
    end

    def inspect
      "Node #{key}"
    end

    def present?
      true
    end
  end
end
