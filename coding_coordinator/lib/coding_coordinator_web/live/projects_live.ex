defmodule CodingCoordinatorWeb.ProjectsLive do
  use CodingCoordinatorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Projects")
     |> assign(:projects, get_all_projects())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mb-8 flex justify-between items-center">
        <div>
          <h1 class="text-4xl font-bold mb-2 text-gray-900 dark:text-gray-100">Projects</h1>
          <p class="text-base-content/70">Manage and coordinate your development projects</p>
        </div>
        <button class="btn btn-primary">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M12 4.5v15m7.5-7.5h-15"
            />
          </svg>
          New Project
        </button>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for project <- @projects do %>
          <div class="card bg-base-100 shadow-xl dark:bg-gray-800">
            <div class="card-body">
              <div class="flex justify-between items-start">
                <div>
                  <h2 class="card-title">
                    <.link navigate={"/projects/#{project.id}"} class="link link-primary">
                      {project.name}
                    </.link>
                  </h2>
                  <p class="text-sm text-base-content/70">{project.description}</p>
                </div>
                <div class={"badge #{badge_color(project.status)} whitespace-nowrap"}>
                  {format_status(project.status)}
                </div>
              </div>
              <div class="mt-4">
                <div class="flex justify-between text-sm mb-1">
                  <span>Progress</span>
                  <span>{project.progress}%</span>
                </div>
                <progress
                  class="progress progress-primary w-full"
                  value={project.progress}
                  max="100"
                >
                </progress>
              </div>
              <div class="flex justify-between items-center mt-4">
                <div class="text-sm text-base-content/70">
                  <div>Tasks: {project.task_count}</div>
                  <div>Agents: {project.agent_count}</div>
                </div>
                <div class="card-actions justify-end">
                  <button class="btn btn-sm">View</button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
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

  defp get_all_projects do
    [
      %{
        id: 1,
        name: "E-commerce API",
        description: "RESTful API for online shopping platform",
        status: "in_progress",
        progress: 65,
        task_count: 12,
        agent_count: 3
      },
      %{
        id: 2,
        name: "Dashboard UI",
        description: "Analytics dashboard for admin panel",
        status: "planning",
        progress: 15,
        task_count: 8,
        agent_count: 2
      },
      %{
        id: 3,
        name: "Auth System",
        description: "Authentication and authorization microservice",
        status: "completed",
        progress: 100,
        task_count: 20,
        agent_count: 4
      },
      %{
        id: 4,
        name: "Payment Gateway",
        description: "Integration with payment providers",
        status: "in_progress",
        progress: 42,
        task_count: 15,
        agent_count: 3
      },
      %{
        id: 5,
        name: "Mobile App Backend",
        description: "Backend API for iOS and Android apps",
        status: "planning",
        progress: 5,
        task_count: 25,
        agent_count: 5
      },
      %{
        id: 6,
        name: "Data Pipeline",
        description: "ETL pipeline for analytics data",
        status: "failed",
        progress: 78,
        task_count: 10,
        agent_count: 2
      }
    ]
  end
end
