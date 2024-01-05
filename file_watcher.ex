defmodule FileWatcher do
  require Logger
  require IngestCSV

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ["/app/data/in"])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic for path and events
     Logger.info("New File found: #{inspect(path)}")
     IngestCSV.load(path)
     Logger.debug(events)
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic when monitor stop
     Logger.info("state: #{inspect(state)}")
    {:noreply, state}
  end
end
