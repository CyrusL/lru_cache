require 'double_linked_list'

describe DoubleLinkedList do
  context "when created" do
    let(:list) { DoubleLinkedList.new }
    it 'has no head and no tail' do
      list.head.should be_nil
      list.tail.should be_nil
    end

    context "adding a node" do
      before do
        @first = list.add("K", "V", "expired at")
      end

      it "has a head and tail" do
        list.head.should be_present
        list.tail.should be_present
        @first.key.should == list.head.key
        @first.key.should == list.tail.key
      end

      it "sets head and tail to nil when it is removed" do
        list.remove_node(@first)
        list.head.should be_nil
        list.tail.should be_nil
      end

      context "having second node" do
        before do
          @second = list.add("K2", "V2", "expired at")
        end

        it "has distint head and tail" do
          @first.key.should == list.tail.key
          @second.key.should == list.head.key
          list.size.should == 2
        end

        context "removing it" do
          before do
            list.remove_node(@second)
          end

          it "back to single node list" do
            list.head.should be_present
            list.tail.should be_present
            @first.key.should == list.head.key
            @first.key.should == list.tail.key
          end
        end

        context 'removing the tails' do
          it "back to single node list" do
            list.remove_node(@first)
            list.head.should be_present
            list.tail.should be_present
            @second.key.should == list.head.key
            @second.key.should == list.tail.key
          end
        end

        context 'adding a third' do
          before do
            @third = list.add('3', '3', 'expired')
          end

          it "is a 3 item list" do
            @first.left.should == nil
            @first.right.should == @second
            @second.left.should == @first
            @second.right.should == @third
            @third.left.should == @second
            @third.right.should be_nil
            list.head.should == @third
          end

          it 'is a 2 item list when removing one in the middle' do
            list.remove_node(@second)
            @first.left.should == nil
            @first.right.should == @third
            @third.left.should == @first
            @third.right.should be_nil
            list.head.should == @third
            list.size.should == 2
          end

          it 'changes head' do
            new_head = list.change_head(@second)
            list.size.should == 3
            list.head.key.should == @second.key
            @first.right.should == @third
            @third.right.should == new_head
          end
        end
      end
    end
  end
end
