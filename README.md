# Coding Coordinator - Phoenix + LiveView + Tailwind v4 + DaisyUI

## Status: ✅ Working

The Phoenix server is successfully running at **http://localhost:4000**

## Project Structure

```
coding_coordinator/
├── lib/
│   ├── coding_coordinator/
│   │   ├── application.ex          # Application supervision tree
│   │   ├── redis.ex               # Redis connection wrapper (TLS enabled)
│   │   └── repo.ex               # Ecto repository
│   └── coding_coordinator_web/
│       ├── controllers/
│       │   ├── page_controller.ex   # Pages controller
│       │   └── error_html.ex
│       ├── components/
│       │   ├── layouts/
│       │   │   └── root.html.heex  # Root layout
│       │   ├── core_components.ex  # Core LiveView components
│       │   └── layouts.ex          # Layout helpers
│       ├── live/
│       │   ├── dashboard_live.ex    # Dashboard LiveView
│       │   ├── projects_live.ex     # Projects list LiveView
│       │   ├── project_live.ex      # Project detail LiveView
│       │   └── tasks_live.ex        # Tasks LiveView
│       ├── endpoint.ex             # Phoenix endpoint
│       ├── router.ex              # Routes
│       └── telemetry.ex
├── assets/
│   ├── js/
│   │   └── app.js               # JavaScript entry point
│   ├── css/
│   │   └── app.css             # Tailwind v4 + DaisyUI styles
│   └── vendor/
│       ├── daisyui.js
│       ├── daisyui-theme.js
│       ├── heroicons.js
│       └── topbar.js
└── config/
    ├── config.exs                # Base configuration
    ├── dev.exs                 # Dev config with Redis settings
    ├── prod.exs                # Production config
    ├── runtime.exs             # Runtime configuration
    └── test.exs                # Test configuration
```

## Features Implemented

### Backend (Phoenix + Elixir)
- **LiveView**: Server-rendered, real-time interactive UI
- **Redis Connection**: GenServer-based Redis client with TLS support
  - Host: redis.banjo-capella.ts.net
  - Port: 443 with TLS
  - Note: Currently configured but may not connect without proper certificates

### Frontend (LiveView + Tailwind + DaisyUI)
- **DaisyUI Components**: Beautiful UI components built on Tailwind CSS
- **Heroicons**: Icon set for UI elements
- **Tailwind v4**: Modern CSS utility classes
- **LiveViews**:
  - Dashboard - Overview with project statistics
  - Projects - Project list with status indicators
  - Project - Task list and agent management view

## Running the Project

### Start the Server

```bash
cd coding_coordinator
mix phx.server
```

The server will be available at **http://localhost:4000**

### Available Pages

- **http://localhost:4000/** - Landing page
- **http://localhost:4000/dashboard** - Dashboard
- **http://localhost:4000/projects** - Projects list
- **http://localhost:4000/projects/:id** - Project detail view

## Known Issues & Notes

1. **Redis Connection**: The Redis connection is configured but may not connect without proper SSL certificates. The application starts successfully even if Redis fails to connect.

2. **Database**: SQLite is configured and a dev database exists at `priv/dev.db`.

3. **Tailwind Watch**: The watchman command is not available on this system. Tailwind builds once and doesn't watch for changes.

## Next Steps for Production

1. **Container Management**: Add Docker integration for spinning up headless agents
2. **Task Queue**: Implement job queue using Redis
3. **AI Integration**: Connect to LLM APIs for planning and execution
4. **Real-time Updates**: Leverage LiveView and PubSub for agent status updates
5. **File Persistence**: Store generated code in S3 or local storage
6. **Authentication**: User accounts and project ownership
7. **Database Models**: Add Project, Task, Agent, and Execution schemas
