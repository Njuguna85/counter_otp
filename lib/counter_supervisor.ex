defmodule CounterSupervisor do
  use Supervisor

  # Client/ public api

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args)
  end

  # Callbacks

  def init(init_args) do
    children = [
      {Counter, init_args}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
