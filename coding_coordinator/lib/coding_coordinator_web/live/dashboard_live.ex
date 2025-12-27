defmodule CodingCoordinatorWeb.DashboardLive do
  use CodingCoordinatorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:projects, get_projects())
     |> assign(:active_tasks, get_active_tasks())
     |> assign(:completed_tasks, get_completed_tasks())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <nav class="relative bg-white shadow-sm">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="flex h-16 justify-between">
            <div class="flex">
              <div class="flex shrink-0 items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  class="h-8 w-auto text-indigo-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                  />
                </svg>
              </div>
              <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                <.link
                  navigate="/"
                  class="inline-flex items-center border-b-2 border-indigo-600 px-1 pt-1 text-sm font-medium text-gray-900"
                >
                  Dashboard
                </.link>
                <.link
                  navigate="/projects"
                  class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                >
                  Projects
                </.link>
                <.link
                  navigate="/tasks"
                  class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                >
                  Tasks
                </.link>
              </div>
            </div>
            <div class="hidden sm:ml-6 sm:flex sm:items-center">
              <button
                type="button"
                class="relative rounded-full p-1 text-gray-400 hover:text-gray-500"
              >
                <span class="absolute -inset-1.5"></span>
                <span class="sr-only">View notifications</span>
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  class="size-6"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </nav>

      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8">
          <h1 class="text-3xl font-bold tracking-tight text-gray-900">Dashboard</h1>
          <p class="mt-2 text-gray-600">
            Monitor your coding agent coordination system
          </p>
        </div>

        <div class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
          <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6">
            <dt class="truncate text-sm font-medium text-gray-500">
              Active Projects
            </dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
              {@projects |> length()}
            </dd>
            <div class="mt-2 text-xs text-gray-400">Ongoing development</div>
          </div>

          <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6">
            <dt class="truncate text-sm font-medium text-gray-500">Active Tasks</dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
              {@active_tasks |> length()}
            </dd>
            <div class="mt-2 text-xs text-gray-400">Running agents</div>
          </div>

          <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6">
            <dt class="truncate text-sm font-medium text-gray-500">
              Completed Tasks
            </dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
              {@completed_tasks}
            </dd>
            <div class="mt-2 text-xs text-gray-400">Successfully executed</div>
          </div>
        </div>

        <div class="mt-8 grid grid-cols-1 gap-6 lg:grid-cols-2">
          <div class="overflow-hidden rounded-md bg-white shadow-sm">
            <div class="border-b border-gray-200 bg-gray-50 px-6 py-4">
              <h3 class="text-base font-semibold text-gray-900">Recent Projects</h3>
            </div>
            <ul role="list" class="divide-y divide-gray-200">
              <%= for project <- @projects do %>
                <li class="px-6 py-4">
                  <div class="flex items-center justify-between">
                    <div class="flex-1">
                      <.link
                        navigate={"/projects/#{project.id}"}
                        class="text-sm font-medium text-gray-900 hover:text-indigo-600"
                      >
                        {project.name}
                      </.link>
                      <div class="mt-1 flex items-center">
                        <div class={"mr-2 inline-flex items-center rounded-md px-2 py-1 text-xs font-medium #{project_badge_classes(project.status)} whitespace-nowrap"}>
                          {format_status(project.status)}
                        </div>
                        <div class="flex-1">
                          <div class="h-2 w-full overflow-hidden rounded-full bg-gray-200">
                            <div
                              class="h-full bg-indigo-600"
                              style={"width: #{project.progress}%"}
                            >
                            </div>
                          </div>
                        </div>
                        <span class="ml-2 text-xs text-gray-500">{project.progress}%</span>
                      </div>
                    </div>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>

          <div class="overflow-hidden rounded-md bg-white shadow-sm">
            <div class="border-b border-gray-200 bg-gray-50 px-6 py-4">
              <h3 class="text-base font-semibold text-gray-900">Active Agents</h3>
            </div>
            <ul role="list" class="divide-y divide-gray-200">
              <%= for task <- @active_tasks do %>
                <li class="px-6 py-4">
                  <div class="flex items-center">
                    <div class="h-10 w-10 flex-none rounded-full bg-indigo-100 flex items-center justify-center text-sm font-medium text-indigo-600">
                      A{task.agent_id}
                    </div>
                    <div class="ml-4 flex-1">
                      <p class="text-sm font-medium text-gray-900">
                        {task.description}
                      </p>
                      <p class="mt-1 text-xs text-gray-500">Agent {task.agent_id}</p>
                    </div>
                    <div class="flex-none">
                      <span class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700">
                        Running
                      </span>
                    </div>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp project_badge_classes("planning"), do: "bg-blue-50 text-blue-700"
  defp project_badge_classes("in_progress"), do: "bg-yellow-50 text-yellow-700"
  defp project_badge_classes("completed"), do: "bg-green-50 text-green-700"
  defp project_badge_classes("failed"), do: "bg-red-50 text-red-700"
  defp project_badge_classes(_), do: "bg-gray-50 text-gray-700"

  defp format_status("planning"), do: "Planning"
  defp format_status("in_progress"), do: "In Progress"
  defp format_status("completed"), do: "Completed"
  defp format_status("failed"), do: "Failed"
  defp format_status(status), do: status

  defp get_projects do
    [
      %{id: 1, name: "E-commerce API", status: "in_progress", progress: 65},
      %{id: 2, name: "Dashboard UI", status: "planning", progress: 15},
      %{id: 3, name: "Auth System", status: "completed", progress: 100},
      %{id: 4, name: "Payment Gateway", status: "in_progress", progress: 42}
    ]
  end

  defp get_active_tasks do
    [
      %{agent_id: "001", description: "Implement user model"},
      %{agent_id: "002", description: "Create database migrations"},
      %{agent_id: "003", description: "Write unit tests"}
    ]
  end

  defp get_completed_tasks do
    127
  end
end
