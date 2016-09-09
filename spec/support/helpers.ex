defmodule ConqueuerSpec.Helpers do

  def start_queue_app do
    start_pool
  end

  def start_queue do
    name = :WorkersQueue
    Conqueuer.Queue.start_link [], [name: name]
    name
  end

  def start_queue_with_limit(limit \\ 1) do
    name = :WorkersQueueWithLimit
    Conqueuer.Queue.start_link [limit: limit], [name: name]
    name
  end

  def start_pool do
    ConqueuerSpec.SomethingWorkerPool.start_link
  end

end
