defmodule CodingCoordinatorWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use CodingCoordinatorWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="flex h-full bg-gray-50 dark:bg-gray-900 lg:static lg:overflow-visible">
      <div class="fixed inset-0 z-50 hidden lg:flex lg:w-72 lg:flex-col">
        <div class="flex grow flex-col gap-y-5 overflow-y-auto border-r border-gray-200 bg-white px-6 dark:border-gray-700 dark:bg-gray-800">
          <div class="flex h-16 shrink-0 items-center gap-2">
            <img src={~p"/images/logo.svg"} width="32" class="h-8 w-auto" />
            <span class="text-lg font-semibold text-gray-900 dark:text-white">CodingCoordinator</span>
          </div>
          <nav class="flex flex-1 flex-col">
            <ul role="list" class="flex flex-1 flex-col gap-y-7">
              <li>
                <ul role="list" class="-mx-2 space-y-1">
                  <li>
                    <.link
                      navigate={~p"/"}
                      class="group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold text-gray-700 hover:bg-gray-50 hover:text-indigo-600 dark:text-gray-200 dark:hover:bg-gray-700 dark:hover:text-indigo-400"
                    >
                      <.icon
                        name="hero-home"
                        class="size-6 shrink-0 text-gray-400 group-hover:text-indigo-600 dark:text-gray-500 dark:group-hover:text-indigo-400"
                      /> Dashboard
                    </.link>
                  </li>
                  <li>
                    <.link
                      navigate={~p"/projects"}
                      class="group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold text-gray-700 hover:bg-gray-50 hover:text-indigo-600 dark:text-gray-200 dark:hover:bg-gray-700 dark:hover:text-indigo-400"
                    >
                      <.icon
                        name="hero-folder"
                        class="size-6 shrink-0 text-gray-400 group-hover:text-indigo-600 dark:text-gray-500 dark:group-hover:text-indigo-400"
                      /> Projects
                    </.link>
                  </li>
                  <li>
                    <.link
                      navigate={~p"/tasks"}
                      class="group flex gap-x-3 rounded-md p-2 text-sm/6 font-semibold text-gray-700 hover:bg-gray-50 hover:text-indigo-600 dark:text-gray-200 dark:hover:bg-gray-700 dark:hover:text-indigo-400"
                    >
                      <.icon
                        name="hero-clipboard-document-list"
                        class="size-6 shrink-0 text-gray-400 group-hover:text-indigo-600 dark:text-gray-500 dark:group-hover:text-indigo-400"
                      /> Tasks
                    </.link>
                  </li>
                </ul>
              </li>
              <li class="-mx-6 mt-auto">
                <div class="flex items-center gap-x-4 px-6 py-3 text-sm/6 font-semibold text-gray-900 dark:text-white">
                  <div class="flex h-8 w-8 items-center justify-center rounded-full bg-indigo-600">
                    <span class="text-sm font-medium text-white">U</span>
                  </div>
                  <span>User</span>
                </div>
              </li>
            </ul>
          </nav>
        </div>
      </div>

      <div class="flex grow flex-col lg:pl-72">
        <header class="sticky top-0 z-40 flex items-center gap-x-6 bg-white px-4 py-4 shadow-sm sm:px-6 lg:px-8 border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700">
          <button type="button" class="-m-2.5 p-2.5 text-gray-700 lg:hidden dark:text-gray-200">
            <span class="sr-only">Open sidebar</span>
            <.icon name="hero-bars-3" class="size-6" />
          </button>
          <div class="flex-1 text-sm/6 font-semibold text-gray-900 lg:hidden dark:text-white">
            Menu
          </div>
          <div class="flex items-center gap-4">
            <.theme_toggle />
          </div>
        </header>

        <main class="flex grow">
          <div class="px-4 py-8 sm:px-6 lg:px-8 w-full">
            {render_slot(@inner_block)}
          </div>
        </main>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex h-8 w-24 items-center rounded-full border border-gray-300 bg-white dark:border-gray-600 dark:bg-gray-800">
      <button
        class="flex h-full w-1/3 items-center justify-center transition-colors hover:bg-gray-200 dark:hover:bg-gray-700"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex h-full w-1/3 items-center justify-center transition-colors hover:bg-gray-200 dark:hover:bg-gray-700"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex h-full w-1/3 items-center justify-center transition-colors hover:bg-gray-200 dark:hover:bg-gray-700"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
