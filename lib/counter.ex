defmodule Counter do
  use GenServer

  # public APIs
  # when we invoke start link, it will call init which will return
  # a tuple of ok and initial_count aka will set the state inside the process
  def start_link(initial_count) do
    GenServer.start_link(__MODULE__, initial_count)
  end

  def increment(pid) do
    GenServer.call(pid, :inc)
  end

  def decrement(pid) do
    GenServer.call(pid, :dec)
  end

  def current(pid) do
    GenServer.call(pid, :current)
  end

  def divide(pid, divisor) do
    GenServer.call(pid, {:divide, divisor})
  end

  # callbacks

  # initialize counter
  # this is a callback function ie wo'nt be called directly
  # will be called by genserver otp library in response to some event
  def init(initial_count) do
    # restore the initial state after a crash
    initial_count =
      case Cache.lookup(__MODULE__) do
        {:ok, count} -> count
        :error -> initial_count
      end

    {:ok, initial_count}
  end

  # handle messages
  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end

  def handle_call(:inc, _from, count) do
    updated_count = count + 1

    # reply to the process that sent the increment message
    {:reply, updated_count, updated_count}
  end

  def handle_call(:dec, _from, count) do
    updated_count = count - 1
    {:reply, updated_count, updated_count}
  end

  def handle_call({:divide, divisor}, _from, count) do
    {:reply, div(count, divisor), count}
  end

  def terminate(_reason, count) do
    Cache.save(__MODULE__, count)
  end
end
