require 'double_linked_list'

class LruCache
  attr_reader :capacity

  def initialize(capacity)
    @items    = Hash.new
    @capacity = capacity
    @list = DoubleLinkedList.new
  end

  def size
    items.size
  end

  def put(k,v, ttl=nil)
    remove_key_if_present(k)
    evist_last_recently_used_if_exceeding_capacity
    @items[k] = @list.add(k, v, ttl ? Time.now + ttl : nil)
  end

  def get(k)
    not_found = nil
    hit = items[k]
    if !hit || hit.expired?
      remove_key_if_present(k)
      return not_found
    else
      list.promote_to_head(hit)
      return hit.data
    end
  end

  private
  attr_reader :list, :items
  def evist_last_recently_used_if_exceeding_capacity
    if items.size >= capacity
      list.remove_node items.delete(list.tail.key)
    end
  end

  def remove_key_if_present(k)
    if items[k]
      list.remove_node(items.delete(k))
    end
  end
end

