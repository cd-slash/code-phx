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
    <Layouts.app flash={@flash}>
      <div class="mb-8">
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">Dashboard</h1>
        <p class="mt-2 text-gray-600 dark:text-gray-400">
          Monitor your coding agent coordination system
        </p>
      </div>

      <div class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
        <div class="rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6 dark:bg-gray-800">
          <dt class="truncate text-sm font-medium text-gray-500 dark:text-gray-400">
            Active Projects
          </dt>
          <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900 dark:text-white">
            {@projects |> length()}
          </dd>
          <div class="mt-2 text-xs text-gray-400">Ongoing development</div>
        </div>

        <div class="rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6 dark:bg-gray-800">
          <dt class="truncate text-sm font-medium text-gray-500 dark:text-gray-400">Active Tasks</dt>
          <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900 dark:text-white">
            {@active_tasks |> length()}
          </dd>
          <div class="mt-2 text-xs text-gray-400">Running agents</div>
        </div>

        <div class="rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6 dark:bg-gray-800">
          <dt class="truncate text-sm font-medium text-gray-500 dark:text-gray-400">
            Completed Tasks
          </dt>
          <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900 dark:text-white">
            {@completed_tasks}
          </dd>
          <div class="mt-2 text-xs text-gray-400">Successfully executed</div>
        </div>
      </div>

      <div class="mt-8 grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div class="rounded-md bg-white shadow-sm dark:bg-gray-800">
          <div class="border-b border-gray-200 bg-gray-50 px-6 py-4 dark:border-gray-700 dark:bg-gray-900">
            <h3 class="text-base font-semibold text-gray-900 dark:text-white">Recent Projects</h3>
          </div>
          <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-700">
            <%= for project <- @projects do %>
              <li class="px-6 py-4">
                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.link
                      navigate={"/projects/#{project.id}"}
                      class="text-sm font-medium text-gray-900 hover:text-indigo-600 dark:text-white dark:hover:text-indigo-400"
                    >
                      {project.name}
                    </.link>
                    <div class="mt-1 flex items-center">
                      <div class={"mr-2 inline-flex items-center rounded-md px-2 py-1 text-xs font-medium #{project_badge_classes(project.status)} whitespace-nowrap"}>
                        {format_status(project.status)}
                      </div>
                      <div class="flex-1">
                        <div class="h-2 w-full overflow-hidden rounded-full bg-gray-200 dark:bg-gray-700">
                          <div
                            class="h-full bg-indigo-600"
                            style={"width: #{project.progress}%"}
                          >
                          </div>
                        </div>
                      </div>
                      <span class="ml-2 text-xs text-gray-500 dark:text-gray-400">
                        {project.progress}%
                      </span>
                    </div>
                  </div>
                </div>
              </li>
            <% end %>
          </ul>
        </div>

        <div class="rounded-md bg-white shadow-sm dark:bg-gray-800">
          <div class="border-b border-gray-200 bg-gray-50 px-6 py-4 dark:border-gray-700 dark:bg-gray-900">
            <h3 class="text-base font-semibold text-gray-900 dark:text-white">Active Agents</h3>
          </div>
          <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-700">
            <%= for task <- @active_tasks do %>
              <li class="px-6 py-4">
                <div class="flex items-center">
                  <div class="h-10 w-10 flex-none rounded-full bg-indigo-100 flex items-center justify-center text-sm font-medium text-indigo-600">
                    A{task.agent_id}
                  </div>
                  <div class="ml-4 flex-1">
                    <p class="text-sm font-medium text-gray-900 dark:text-white">
                      {task.description}
                    </p>
                    <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">Agent {task.agent_id}</p>
                  </div>
                  <div class="flex-none">
                    <span class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700 dark:bg-green-900/30 dark:text-green-400">
                      Running
                    </span>
                  </div>
                </div>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    </Layouts.app>
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
