defmodule CodingCoordinatorWeb.ProjectLive do
  use CodingCoordinatorWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    project = get_project(id)

    {:ok,
     socket
     |> assign(:page_title, project.name)
     |> assign(:project, project)
     |> assign(:tasks, get_tasks(id))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mb-8">
        <.link navigate="/projects" class="link link-neutral">
          ← Back to Projects
        </.link>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2">
          <div class="card bg-base-100 shadow-xl mb-6 dark:bg-gray-800">
            <div class="card-body">
              <div class="flex justify-between items-start">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 dark:text-gray-100">{@project.name}</h1>
                  <p class="text-base-content/70 mt-2">{@project.description}</p>
                </div>
                <div class={"badge #{badge_color(@project.status)} badge-lg whitespace-nowrap"}>
                  {format_status(@project.status)}
                </div>
              </div>
              <div class="mt-4">
                <div class="flex justify-between mb-1">
                  <span class="font-medium">Overall Progress</span>
                  <span class="font-medium">{@project.progress}%</span>
                </div>
                <progress
                  class="progress progress-primary w-full"
                  value={@project.progress}
                  max="100"
                >
                </progress>
              </div>
            </div>
          </div>

          <div class="card bg-base-100 shadow-xl dark:bg-gray-800">
            <div class="card-body">
              <h2 class="card-title mb-4">Tasks</h2>
              <div class="overflow-x-auto">
                <table class="table">
                  <thead>
                    <tr>
                      <th>Task</th>
                      <th>Agent</th>
                      <th>Container</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%= for task <- @tasks do %>
                      <tr>
                        <td>
                          <div class="flex items-center gap-2">
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              viewBox="0 0 24 24"
                              fill="none"
                              class="size-5 text-gray-400"
                            >
                              <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-1.073-1.916 48.432 48.432 0 0 0-1.123-.081M9 18h3.75"
                              />
                            </svg>
                            <div>
                              <div class="font-medium">{task.title}</div>
                              <div class="text-sm text-base-content/70">
                                Container: {task.container}
                              </div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <div class="flex items-center gap-2">
                            <div class="avatar placeholder">
                              <div class="bg-neutral text-neutral-content rounded-full w-8">
                                <span class="text-xs">A{task.agent_id}</span>
                              </div>
                            </div>
                            <div class="text-sm font-medium">Agent {task.agent_id}</div>
                          </div>
                        </td>
                        <td>
                          <div class={[
                            "badge",
                            "whitespace-nowrap",
                            task.status == "pending" && "badge-neutral",
                            task.status == "running" && "badge-info",
                            task.status == "completed" && "badge-success",
                            task.status == "failed" && "badge-error",
                            task.status not in ["pending", "running", "completed", "failed"] &&
                              "badge-neutral"
                          ]}>
                            {task.status}
                          </div>
                        </td>
                        <td>
                          <button class="btn btn-ghost btn-xs">Details</button>
                        </td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="card bg-base-100 shadow-xl mb-6 dark:bg-gray-800">
            <div class="card-body">
              <h2 class="card-title">Project Details</h2>
              <div class="stats stats-vertical shadow mt-4">
                <div class="stat">
                  <div class="stat-title">Total Tasks</div>
                  <div class="stat-value text-2xl">{@project.task_count}</div>
                </div>
                <div class="stat">
                  <div class="stat-title">Active Agents</div>
                  <div class="stat-value text-2xl">{@project.agent_count}</div>
                </div>
                <div class="stat">
                  <div class="stat-title">Completed</div>
                  <div class="stat-value text-2xl text-success">
                    {completed_count(@tasks)}
                  </div>
                </div>
                <div class="stat">
                  <div class="stat-title">Failed</div>
                  <div class="stat-value text-2xl text-error">
                    {failed_count(@tasks)}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="card bg-base-100 shadow-xl dark:bg-gray-800">
            <div class="card-body">
              <h2 class="card-title">Plan</h2>
              <div class="text-sm text-base-content/70 mt-2">
                <p class="mb-2">
                  This project will be executed by autonomous coding agents working in parallel on containerized environments.
                </p>
                <p>
                  Each task is assigned to a headless agent that operates in isolation, with coordination managed by the central system.
                </p>
              </div>
              <div class="card-actions justify-end mt-4">
                <button class="btn btn-primary btn-sm">View Full Plan</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp badge_color("planning"), do: "badge-info"
  defp badge_color("in_progress"), do: "badge-warning"
  defp badge_color("completed"), do: "badge-success"
  defp badge_color("failed"), do: "badge-error"
  defp badge_color(_), do: "badge-neutral"

  defp format_status("planning"), do: "Planning"
  defp format_status("in_progress"), do: "In Progress"
  defp format_status("completed"), do: "Completed"
  defp format_status("failed"), do: "Failed"
  defp format_status(status), do: status

  defp completed_count(tasks) do
    tasks
    |> Enum.count(fn t -> t.status == "completed" end)
  end

  defp failed_count(tasks) do
    tasks
    |> Enum.count(fn t -> t.status == "failed" end)
  end

  defp get_project(id) do
    projects = %{
      "1" => %{
        id: 1,
        name: "E-commerce API",
        description: "RESTful API for online shopping platform",
        status: "in_progress",
        progress: 65,
        task_count: 12,
        agent_count: 3
      },
      "2" => %{
        id: 2,
        name: "Dashboard UI",
        description: "Analytics dashboard for admin panel",
        status: "planning",
        progress: 15,
        task_count: 8,
        agent_count: 2
      },
      "3" => %{
        id: 3,
        name: "Auth System",
        description: "Authentication and authorization microservice",
        status: "completed",
        progress: 100,
        task_count: 20,
        agent_count: 4
      },
      "4" => %{
        id: 4,
        name: "Payment Gateway",
        description: "Integration with payment providers",
        status: "in_progress",
        progress: 42,
        task_count: 15,
        agent_count: 3
      }
    }

    Map.get(projects, id, %{
      id: String.to_integer(id),
      name: "Unknown Project",
      description: "Project not found",
      status: "planning",
      progress: 0,
      task_count: 0,
      agent_count: 0
    })
  end

  defp get_tasks(project_id) do
    tasks = %{
      "1" => [
        %{
          id: 1,
          title: "Setup project structure",
          description: "Initialize Phoenix project with LiveView",
          agent_id: "1",
          container: "agent-001",
          status: "completed"
        },
        %{
          id: 2,
          title: "Design database schema",
          description: "Create Ecto schemas for products, users, orders",
          agent_id: "2",
          container: "agent-002",
          status: "completed"
        },
        %{
          id: 3,
          title: "Implement user authentication",
          description: "Add JWT-based authentication",
          agent_id: "3",
          container: "agent-003",
          status: "running"
        },
        %{
          id: 4,
          title: "Create product endpoints",
          description: "CRUD operations for products",
          agent_id: "1",
          container: "agent-001",
          status: "pending"
        }
      ],
      "2" => [
        %{
          id: 1,
          title: "Design UI mockups",
          description: "Create wireframes for dashboard",
          agent_id: "1",
          container: "agent-001",
          status: "completed"
        },
        %{
          id: 2,
          title: "Setup chart components",
          description: "Integrate charting library",
          agent_id: "2",
          container: "agent-002",
          status: "pending"
        }
      ]
    }

    Map.get(tasks, project_id, [])
  end
end
