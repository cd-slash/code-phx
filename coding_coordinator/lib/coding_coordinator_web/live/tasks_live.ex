defmodule CodingCoordinatorWeb.TasksLive do
  use CodingCoordinatorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tasks")
     |> assign(:tasks, get_all_tasks())
     |> assign(:filter, "all")}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter}, socket) do
    {:noreply,
     socket
     |> assign(:filter, filter)
     |> assign(:tasks, get_filtered_tasks(filter))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mb-8">
        <h1 class="text-4xl font-bold mb-2 text-gray-900 dark:text-white">Tasks</h1>
        <p class="text-gray-600 dark:text-gray-400">Monitor and manage all agent tasks</p>
      </div>

      <div class="rounded-xl bg-white shadow-lg dark:bg-gray-800">
        <div class="p-6">
          <div class="flex flex-wrap gap-2 mb-4">
            <button
              class={"rounded-md px-3 py-2 text-sm font-medium #{@filter == "all" && "bg-indigo-600 text-white" || "text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700"}"}
              phx-click="filter"
              phx-value-filter="all"
            >
              All
            </button>
            <button
              class={"rounded-md px-3 py-2 text-sm font-medium #{@filter == "pending" && "bg-indigo-600 text-white" || "text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700"}"}
              phx-click="filter"
              phx-value-filter="pending"
            >
              Pending
            </button>
            <button
              class={"rounded-md px-3 py-2 text-sm font-medium #{@filter == "running" && "bg-indigo-600 text-white" || "text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700"}"}
              phx-click="filter"
              phx-value-filter="running"
            >
              Running
            </button>
            <button
              class={"rounded-md px-3 py-2 text-sm font-medium #{@filter == "completed" && "bg-indigo-600 text-white" || "text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700"}"}
              phx-click="filter"
              phx-value-filter="completed"
            >
              Completed
            </button>
            <button
              class={"rounded-md px-3 py-2 text-sm font-medium #{@filter == "failed" && "bg-indigo-600 text-white" || "text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700"}"}
              phx-click="filter"
              phx-value-filter="failed"
            >
              Failed
            </button>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
              <thead>
                <tr class="bg-gray-50 dark:bg-gray-900">
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Task
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Project
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Agent
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Container
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Status
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Duration
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200 bg-white dark:divide-gray-700 dark:bg-gray-800">
                <%= for task <- @tasks do %>
                  <tr class="hover:bg-gray-50 dark:hover:bg-gray-700">
                    <td class="px-6 py-4">
                      <div class="font-medium text-gray-900 dark:text-white">{task.title}</div>
                      <div class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                        {task.description}
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <.link
                        navigate={"/projects/#{task.project_id}"}
                        class="text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300"
                      >
                        {task.project_name}
                      </.link>
                    </td>
                    <td class="px-6 py-4">
                      <div class="flex items-center gap-2">
                        <div class="h-8 w-8 flex items-center justify-center rounded-full bg-gray-100 text-sm font-medium text-gray-600 dark:bg-gray-700 dark:text-gray-300">
                          A{task.agent_id}
                        </div>
                        <div class="text-sm text-gray-900 dark:text-white">Agent {task.agent_id}</div>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <code class="rounded bg-gray-100 px-2 py-1 text-xs text-gray-700 dark:bg-gray-900 dark:text-gray-300">
                        {task.container}
                      </code>
                    </td>
                    <td class="px-6 py-4">
                      <div class={task_badge_class(task.status)}>{task.status}</div>
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-600 dark:text-gray-400">
                      {task.duration}
                    </td>
                    <td class="px-6 py-4">
                      <div class="flex gap-2">
                        <button class="rounded-md px-2 py-1 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700">
                          Logs
                        </button>
                        <%= if task.status in ["pending", "running"] do %>
                          <button class="rounded-md px-2 py-1 text-sm font-medium text-red-600 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/20">
                            Stop
                          </button>
                        <% end %>
                      </div>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp task_badge_class("pending"), do: "badge badge-neutral whitespace-nowrap"
  defp task_badge_class("running"), do: "badge badge-info whitespace-nowrap"
  defp task_badge_class("completed"), do: "badge badge-success whitespace-nowrap"
  defp task_badge_class("failed"), do: "badge badge-error whitespace-nowrap"
  defp task_badge_class(_), do: "badge badge-neutral whitespace-nowrap"

  defp get_filtered_tasks("all"), do: get_all_tasks()

  defp get_filtered_tasks(filter) do
    get_all_tasks()
    |> Enum.filter(fn t -> t.status == filter end)
  end

  defp get_all_tasks do
    [
      %{
        id: 1,
        title: "Setup project structure",
        description: "Initialize Phoenix project with LiveView",
        project_id: 1,
        project_name: "E-commerce API",
        agent_id: "1",
        container: "agent-001",
        status: "completed",
        duration: "5m 23s"
      },
      %{
        id: 2,
        title: "Design database schema",
        description: "Create Ecto schemas for products, users, orders",
        project_id: 1,
        project_name: "E-commerce API",
        agent_id: "2",
        container: "agent-002",
        status: "completed",
        duration: "8m 45s"
      },
      %{
        id: 3,
        title: "Implement user authentication",
        description: "Add JWT-based authentication",
        project_id: 1,
        project_name: "E-commerce API",
        agent_id: "3",
        container: "agent-003",
        status: "running",
        duration: "12m 30s"
      },
      %{
        id: 4,
        title: "Create product endpoints",
        description: "CRUD operations for products",
        project_id: 1,
        project_name: "E-commerce API",
        agent_id: "1",
        container: "agent-001",
        status: "pending",
        duration: "-"
      },
      %{
        id: 5,
        title: "Design UI mockups",
        description: "Create wireframes for dashboard",
        project_id: 2,
        project_name: "Dashboard UI",
        agent_id: "1",
        container: "agent-004",
        status: "completed",
        duration: "3m 15s"
      },
      %{
        id: 6,
        title: "Setup chart components",
        description: "Integrate charting library",
        project_id: 2,
        project_name: "Dashboard UI",
        agent_id: "2",
        container: "agent-005",
        status: "pending",
        duration: "-"
      },
      %{
        id: 7,
        title: "Create OAuth flow",
        description: "Implement Google and GitHub OAuth",
        project_id: 3,
        project_name: "Auth System",
        agent_id: "1",
        container: "agent-006",
        status: "completed",
        duration: "10m 12s"
      },
      %{
        id: 8,
        title: "Setup Stripe integration",
        description: "Configure Stripe webhook and payment processing",
        project_id: 4,
        project_name: "Payment Gateway",
        agent_id: "2",
        container: "agent-007",
        status: "failed",
        duration: "7m 44s"
      },
      %{
        id: 9,
        title: "Implement payment validation",
        description: "Add validation for payment requests",
        project_id: 4,
        project_name: "Payment Gateway",
        agent_id: "3",
        container: "agent-008",
        status: "pending",
        duration: "-"
      },
      %{
        id: 10,
        title: "Create refund flow",
        description: "Implement refund processing",
        project_id: 4,
        project_name: "Payment Gateway",
        agent_id: "1",
        container: "agent-009",
        status: "pending",
        duration: "-"
      }
    ]
  end
end
