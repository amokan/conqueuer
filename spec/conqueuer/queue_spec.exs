defmodule ConqueuerSpec.Queue do

	use ESpec

  alias Conqueuer.Queue

  before do
    queue_name = ConqueuerSpec.Helpers.start_queue
    Queue.empty queue_name

    limited_queue_name = ConqueuerSpec.Helpers.start_queue_with_limit(2)
    Queue.empty limited_queue_name

    { :ok, [queue: queue_name, limited_queue: limited_queue_name, item: 1] }
  end

  defmodule AnEmptyQueueSpec do

    use ESpec, shared: true

    it "should not agree the item is a member" do
      expect( Queue.member?( shared.queue, shared.item )).to be_false
    end

    it "should have a size of 0" do
      expect( Queue.size( shared.queue )).to eq( 0 )
    end

    it "should not provide a next item" do
      expect( Queue.next( shared.queue )).to eq( :empty )
    end

  end

  describe "when the queue is empty" do

    it_behaves_like AnEmptyQueueSpec

  end

  describe "when an item is enqueued" do

    before do
      Queue.enqueue( shared.queue, shared.item )
    end

    it "should agree the item is a member" do
      expect( Queue.member?( shared.queue, shared.item )).to be_true
    end

    it "should have a size of 1" do
      expect( Queue.size( shared.queue )).to eq( 1 )
    end

    it "should have a limit of `:unlimited`" do
      expect( Queue.limit( shared.queue )).to eq( :unlimited )
    end

    it "should respond to limit_reached? with false" do
      expect( Queue.limit_reached?( shared.queue )).to eq( false )
    end

    it "should provide the item next" do
      {:ok, next_item} = Queue.next( shared.queue )
      expect( next_item ).to eq( shared.item )
    end

    describe "and then the queue is emptied" do

      before do
        Queue.empty( shared.queue )
      end

      it_behaves_like AnEmptyQueueSpec

    end

  end

  describe "when limiting queue size is empty" do
    before do
      Queue.enqueue( shared.limited_queue, shared.item )
    end

    it "should have a size of 1" do
      expect( Queue.size( shared.limited_queue )).to eq( 1 )
    end

    it "should have a limit of 2" do
      expect( Queue.limit( shared.limited_queue )).to eq( 2 )
    end

    it "should respond to limit_reached? with false" do
      expect( Queue.limit_reached?( shared.limited_queue )).to be_false
    end

    describe "when limiting queue size is at or over the limit" do
      before do
        Queue.enqueue( shared.limited_queue, shared.item )
      end

      it "should have a size of 2" do
        expect( Queue.size( shared.limited_queue )).to eq( 2 )
      end

      it "should have a limit of 2" do
        expect( Queue.limit( shared.limited_queue )).to eq( 2 )
      end

      it "should respond to limit_reached? with true" do
        expect( Queue.limit_reached?( shared.limited_queue )).to be_true
      end

      it "should prevent subsequent items from being queued and respond with `:limit_reached`" do
        expect( Queue.enqueue( shared.limited_queue, shared.item )).to eq( :limit_reached )
      end
    end
    
  end

end
