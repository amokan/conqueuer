defmodule Conqueuer.Queue do
  @moduledoc """
  """

  use GenServer

  # Public API ############

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link __MODULE__, args, opts
  end

  def empty( queue ) do
    GenServer.cast queue, :empty
  end

  def enqueue( queue , item) do
    GenServer.call queue, {:enqueue, item}
  end

  def member?( queue , item) do
    GenServer.call queue, {:member?, item}
  end

  def next( queue ) do
    GenServer.call queue, :next
  end

  def size( queue ) do
    GenServer.call queue, :size
  end

  def limit( queue ) do
    GenServer.call queue, :limit
  end

  def limit_reached?( queue ) do
    GenServer.call queue, :limit_reached?
  end

  # Private API ############

  def init( args ) do
    limit = Keyword.get(args, :limit, :unlimited)

    {:ok, %{queue: :queue.new, limit: limit}}
  end

  def handle_cast(:empty, state) do
    {:noreply, %{state | queue: :queue.new}}
  end

  def handle_call({:enqueue, item}, _from, %{queue: queue, limit: limit} = state) when is_integer(limit) do
    if queue_size(queue) >= limit do
      {:reply, :limit_reached, state}
    else
      queue = :queue.in(item, queue)
      {:reply, :ok, %{state | queue: queue}}
    end
  end
  def handle_call({:enqueue, item}, _from, %{queue: queue} = state) do
    queue = :queue.in(item, queue)
    {:reply, :ok, %{state | queue: queue}}
  end

  def handle_call({:member?, item}, _from, %{queue: queue} = state) do
    {:reply, :queue.member(item, queue), state}
  end

  def handle_call(:next, _from, %{queue: queue} = state) do
    case :queue.out(queue) do
      {{:value, item}, queue} ->
        {:reply, {:ok, item}, %{state | queue: queue}}
      {:empty, {[], []}} ->
        {:reply, :empty, state}
    end
  end

  def handle_call(:size, _from, %{queue: queue} = state) do
    {:reply, queue_size(queue), state}
  end

  def handle_call(:limit, _from, %{limit: limit} = state) do
    {:reply, limit, state}
  end

  def handle_call(:limit_reached?, _from, %{queue: queue, limit: limit} = state) when is_integer(limit) do
    is_over_limt = queue_size(queue) >= limit
    {:reply, is_over_limt, state}
  end
  def handle_call(:limit_reached?, _from, state) do
    {:reply, false, state}
  end

  defp queue_size(queue) do
    :queue.len(queue)
  end

end
