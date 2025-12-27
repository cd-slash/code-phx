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
    <div class="min-h-screen bg-base-200">
      <div class="navbar bg-base-100 shadow-lg">
        <div class="flex-1">
          <a class="btn btn-ghost text-xl">Coding Coordinator</a>
        </div>
        <div class="flex-none">
          <ul class="menu menu-horizontal px-1">
            <li>
              <.link navigate="/">Dashboard</.link>
            </li>
            <li>
              <.link navigate="/projects">Projects</.link>
            </li>
            <li>
              <.link navigate="/tasks">Tasks</.link>
            </li>
          </ul>
        </div>
      </div>

      <div class="container mx-auto p-6">
        <div class="mb-8">
          <h1 class="text-4xl font-bold mb-2">Tasks</h1>
          <p class="text-base-content/70">Monitor and manage all agent tasks</p>
        </div>

        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <div class="flex flex-wrap gap-2 mb-4">
              <button
                class={"btn btn-sm #{@filter == "all" && "btn-primary" || "btn-ghost"}"}
                phx-click="filter"
                phx-value-filter="all"
              >
                All
              </button>
              <button
                class={"btn btn-sm #{@filter == "pending" && "btn-primary" || "btn-ghost"}"}
                phx-click="filter"
                phx-value-filter="pending"
              >
                Pending
              </button>
              <button
                class={"btn btn-sm #{@filter == "running" && "btn-primary" || "btn-ghost"}"}
                phx-click="filter"
                phx-value-filter="running"
              >
                Running
              </button>
              <button
                class={"btn btn-sm #{@filter == "completed" && "btn-primary" || "btn-ghost"}"}
                phx-click="filter"
                phx-value-filter="completed"
              >
                Completed
              </button>
              <button
                class={"btn btn-sm #{@filter == "failed" && "btn-primary" || "btn-ghost"}"}
                phx-click="filter"
                phx-value-filter="failed"
              >
                Failed
              </button>
            </div>

            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th>Task</th>
                    <th>Project</th>
                    <th>Agent</th>
                    <th>Container</th>
                    <th>Status</th>
                    <th>Duration</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for task <- @tasks do %>
                    <tr>
                      <td>
                        <div class="font-medium">{task.title}</div>
                        <div class="text-sm text-base-content/70">{task.description}</div>
                      </td>
                      <td>
                        <.link
                          navigate={"/projects/#{task.project_id}"}
                          class="link link-primary"
                        >
                          {task.project_name}
                        </.link>
                      </td>
                      <td>
                        <div class="flex items-center gap-2">
                          <div class="avatar placeholder">
                            <div class="bg-neutral text-neutral-content rounded-full w-8">
                              <span class="text-xs">A{task.agent_id}</span>
                            </div>
                          </div>
                          <div class="text-sm">Agent {task.agent_id}</div>
                        </div>
                      </td>
                      <td>
                        <code class="text-xs">{task.container}</code>
                      </td>
                      <td>
                        <div class={task_badge_class(task.status)}>{task.status}</div>
                      </td>
                      <td>
                        <div class="text-sm">{task.duration}</div>
                      </td>
                      <td>
                        <div class="flex gap-2">
                          <button class="btn btn-ghost btn-xs">Logs</button>
                          <%= if task.status in ["pending", "running"] do %>
                            <button class="btn btn-ghost btn-xs text-error">
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
      </div>
    </div>
    """
  end

  defp task_badge_class("pending"), do: "badge badge-neutral"
  defp task_badge_class("running"), do: "badge badge-info"
  defp task_badge_class("completed"), do: "badge badge-success"
  defp task_badge_class("failed"), do: "badge badge-error"
  defp task_badge_class(_), do: "badge badge-neutral"

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
