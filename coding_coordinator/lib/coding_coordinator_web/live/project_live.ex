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
        <.link
          navigate="/projects"
          class="text-sm text-gray-600 hover:text-indigo-600 dark:text-gray-400 dark:hover:text-indigo-400"
        >
          ← Back to Projects
        </.link>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2">
          <div class="rounded-xl bg-white shadow-lg mb-6 dark:bg-gray-800">
            <div class="p-6">
              <div class="flex justify-between items-start">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 dark:text-white">{@project.name}</h1>
                  <p class="mt-2 text-gray-600 dark:text-gray-400">{@project.description}</p>
                </div>
                <div class={"inline-flex items-center rounded-md px-2 py-1 text-xs font-medium #{badge_color(@project.status)} whitespace-nowrap"}>
                  {format_status(@project.status)}
                </div>
              </div>
              <div class="mt-4">
                <div class="flex justify-between mb-1">
                  <span class="font-medium text-gray-700 dark:text-gray-200">Overall Progress</span>
                  <span class="font-medium text-gray-700 dark:text-gray-200">
                    {@project.progress}%
                  </span>
                </div>
                <div class="h-2 w-full overflow-hidden rounded-full bg-gray-200 dark:bg-gray-700">
                  <div
                    class="h-full bg-indigo-600 dark:bg-indigo-500"
                    style={"width: #{@project.progress}%"}
                  >
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="rounded-xl bg-white shadow-lg dark:bg-gray-800">
            <div class="p-6">
              <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Tasks</h2>
              <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                  <thead>
                    <tr class="bg-gray-50 dark:bg-gray-900">
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                        Task
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
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200 bg-white dark:divide-gray-700 dark:bg-gray-800">
                    <%= for task <- @tasks do %>
                      <tr class="hover:bg-gray-50 dark:hover:bg-gray-700">
                        <td class="px-6 py-4">
                          <div class="flex items-center gap-2">
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              viewBox="0 0 24 24"
                              fill="none"
                              class="size-5 text-gray-400 dark:text-gray-600"
                            >
                              <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-1.073-1.916 48.432 48.432 0 0 0-1.123-.081M9 18h3.75"
                              />
                            </svg>
                            <div>
                              <div class="font-medium text-gray-900 dark:text-white">
                                {task.title}
                              </div>
                              <div class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                                Container: {task.container}
                              </div>
                            </div>
                          </div>
                        </td>
                        <td class="px-6 py-4">
                          <div class="flex items-center gap-2">
                            <div class="h-8 w-8 flex items-center justify-center rounded-full bg-gray-100 text-sm font-medium text-gray-600 dark:bg-gray-700 dark:text-gray-300">
                              A{task.agent_id}
                            </div>
                            <div class="text-sm font-medium text-gray-900 dark:text-white">
                              Agent {task.agent_id}
                            </div>
                          </div>
                        </td>
                        <td class="px-6 py-4">
                          <code class="rounded bg-gray-100 px-2 py-1 text-xs text-gray-700 dark:bg-gray-900 dark:text-gray-300">
                            {task.container}
                          </code>
                        </td>
                        <td class="px-6 py-4">
                          <div class={[
                            "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium",
                            "whitespace-nowrap",
                            task.status == "pending" &&
                              "bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300",
                            task.status == "running" &&
                              "bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400",
                            task.status == "completed" &&
                              "bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-400",
                            task.status == "failed" &&
                              "bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-400",
                            task.status not in ["pending", "running", "completed", "failed"] &&
                              "bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300"
                          ]}>
                            {task.status}
                          </div>
                        </td>
                        <td class="px-6 py-4">
                          <button class="rounded-md px-2 py-1 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:text-gray-200 dark:hover:bg-gray-700">
                            Details
                          </button>
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
          <div class="rounded-xl bg-white shadow-lg mb-6 dark:bg-gray-800">
            <div class="p-6">
              <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Project Details</h2>
              <div class="mt-4 grid grid-cols-1 gap-4">
                <div class="rounded-lg bg-gray-50 px-4 py-3 dark:bg-gray-900">
                  <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Total Tasks</div>
                  <div class="mt-1 text-2xl font-semibold text-gray-900 dark:text-white">
                    {@project.task_count}
                  </div>
                </div>
                <div class="rounded-lg bg-gray-50 px-4 py-3 dark:bg-gray-900">
                  <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
                    Active Agents
                  </div>
                  <div class="mt-1 text-2xl font-semibold text-gray-900 dark:text-white">
                    {@project.agent_count}
                  </div>
                </div>
                <div class="rounded-lg bg-gray-50 px-4 py-3 dark:bg-gray-900">
                  <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Completed</div>
                  <div class="mt-1 text-2xl font-semibold text-green-600 dark:text-green-400">
                    {completed_count(@tasks)}
                  </div>
                </div>
                <div class="rounded-lg bg-gray-50 px-4 py-3 dark:bg-gray-900">
                  <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Failed</div>
                  <div class="mt-1 text-2xl font-semibold text-red-600 dark:text-red-400">
                    {failed_count(@tasks)}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="rounded-xl bg-white shadow-lg dark:bg-gray-800">
            <div class="p-6">
              <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Plan</h2>
              <div class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                <p class="mb-2">
                  This project will be executed by autonomous coding agents working in parallel on containerized environments.
                </p>
                <p>
                  Each task is assigned to a headless agent that operates in isolation, with coordination managed by central system.
                </p>
              </div>
              <div class="mt-4 flex justify-end">
                <button class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700 dark:bg-indigo-500 dark:hover:bg-indigo-600">
                  View Full Plan
                </button>
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
