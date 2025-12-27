# Coding Coordinator - Phoenix + Inertia.js + React + Tailwind v4 + shadcn/ui

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
│       │   ├── page_controller.ex   # Demo pages controller
│       │   └── error_json.ex
│       ├── layouts/
│       │   └── layouts.ex        # Phoenix layout module
│       ├── endpoint.ex             # Phoenix endpoint with Inertia
│       ├── router.ex              # Routes for demo pages
│       └── telemetry.ex
├── assets/
│   ├── js/
│   │   ├── app.tsx              # Inertia React entry point
│   │   ├── components/
│   │   │   └── ui/             # shadcn/ui components
│   │   │       ├── button.tsx
│   │   │       ├── badge.tsx
│   │   │       └── card.tsx
│   │   ├── lib/
│   │   │   └── utils.ts         # Utility functions (cn)
│   │   └── pages/
│   │       ├── Index.tsx         # Landing page
│   │       ├── Projects.tsx       # Projects list
│   │       └── Project.tsx      # Project detail view
│   ├── css/
│   │   └── app.css             # Tailwind v4 styles
│   └── package.json             # NPM dependencies
└── config/
    ├── config.exs                # Base configuration
    ├── dev.exs                 # Dev config with Redis settings
    └── runtime.exs

## Features Implemented

### Backend (Phoenix + Elixir)
- **Inertia.js Integration**: Plug configured in endpoint for seamless SPA
- **Redis Connection**: GenServer-based Redis client with TLS support
  - Host: redis.banjo-capella.ts.net
  - Port: 443 with TLS
  - Note: Currently configured but may not connect without proper certificates
- **Demo Pages**:
  - `/` - Landing page
  - `/projects` - List of coding projects
  - `/projects/:id` - Project detail with tasks and agents

### Frontend (React + Inertia.js)
- **Inertia.js React Adapter**: Client-side routing and state management
- **shadcn/ui Components**:
  - Button (multiple variants)
  - Badge (status indicators)
  - Card (content containers)
- **Tailwind v4**: Modern CSS utility classes
- **Demo Pages**:
  - Index - Gradient landing with feature cards
  - Projects - Project list with status badges
  - Project - Task list and agent management view

## Running the Project

### Start the Server

```bash
cd coding_coordinator
mix phx.server
```

The server will be available at **http://localhost:4000**

### Available Pages

- **http://localhost:4000/** - Landing page with feature overview
- **http://localhost:4000/projects** - Projects list (3 demo projects)
- **http://localhost:4000/projects/1** - Project detail view

### Frontend Assets

Build JavaScript (if needed):
```bash
cd coding_coordinator/assets
npx esbuild js/app.tsx --bundle --target=es2022 --format=esm --outfile=../priv/static/assets/js/app.js --loader:.tsx=tsx --jsx=automatic --external:/fonts/* --external:/images/* --alias:@=.
```

## Known Issues & Notes

1. **Redis Connection**: The Redis connection is configured but may not connect without proper SSL certificates. The application starts successfully even if Redis fails to connect.

2. **PostgreSQL**: Database is configured but not required for the demo pages. No tables need to be created for the basic demo.

3. **Tailwind Watch**: The watchman command is not available on this system. Tailwind builds once and doesn't watch for changes.

## Next Steps for Production

1. **Container Management**: Add Docker integration for spinning up headless agents
2. **Task Queue**: Implement job queue using Redis
3. **AI Integration**: Connect to LLM APIs for planning and execution
4. **Agent Communication**: WebSocket channels for real-time agent updates
5. **File Persistence**: Store generated code in S3 or local storage
6. **Authentication**: User accounts and project ownership
7. **Database Models**: Add Project, Task, Agent, and Execution schemas
