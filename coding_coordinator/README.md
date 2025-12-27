# Coding Coordinator

A Phoenix LiveView application for coordinating autonomous coding agents. The system creates execution plans, splits them into tasks, and spins up headless agents in containerized environments to work on each task in parallel.

## Features

- **Project Management**: Create and track development projects
- **Task Coordination**: Split projects into tasks and assign to autonomous agents
- **Real-time Monitoring**: LiveView interfaces for monitoring agent activity
- **Agent Containerization**: Each agent runs in an isolated container
- **Redis Integration**: State management using Redis at `redis.banjo-capella.ts.net:443` with TLS

## Tech Stack

- **Backend**: Elixir 1.19.4 with Phoenix 1.8.3
- **Frontend**: Phoenix LiveView with Tailwind CSS v4
- **UI Framework**: daisyUI (included with Phoenix)
- **Database**: PostgreSQL
- **Cache/State**: Redis with TLS

## Getting Started

### Prerequisites

- Elixir 1.15+
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. Install dependencies:
   ```bash
   cd coding_coordinator
   mix setup
   ```

2. Configure your database in `config/dev.exs`:
   ```elixir
   config :coding_coordinator, CodingCoordinator.Repo,
     username: "postgres",
     password: "postgres",
     hostname: "localhost",
     database: "coding_coordinator_dev"
   ```

3. Create and migrate the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

4. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

5. Visit [`localhost:4000`](http://localhost:4000) in your browser

## Tailwind Plus Integration

The project is set up with Tailwind CSS v4 and daisyUI. If you have a Tailwind Plus subscription, you can download all UI components programmatically:

### Using the Tailwind Plus Downloader

1. Install and run the downloader:
   ```bash
   npx github:richardkmichael/tailwindplus-downloader#latest
   ```

2. Enter your Tailwind Plus credentials when prompted
3. This will download all components to a JSON file

### Using Components with an LLM Agent

The downloader creates a `tailwindplus-components-*.json` file. For LLM-assisted development:

1. Generate a skeleton file (smaller, just structure):
   ```bash
   jq '
   def walk:
     . as $in |
       if type == "object" then
         reduce keys[] as $key ({}; . + {($key): ($in[$key] | walk)})
       elif type == "array" then
         map(walk)
       elif type == "string" then
         if length > 100 then "<CONTENT>" else . end
       else .
       end;
   . + {"tailwindplus": (.tailwindplus | walk)}
   ' tailwindplus-components-*.json > tailwindplus-skeleton.json
   ```

2. The skeleton can be used to search for components, and `jq` can extract full component code:
   ```bash
   jq '.tailwindplus.Marketing."Page Sections"."Hero Sections"."Simple centered".snippets[] | select(.name == "html" and .version == 4) | .code' --raw-output tailwindplus-components.json
   ```

## Demo Pages

The project includes demo pages showcasing the coding coordinator concept:

- **Dashboard**: Overview of active projects, tasks, and agents
- **Projects**: Grid view of all projects with status and progress
- **Project Detail**: Individual project view with task breakdown and agent assignments
- **Tasks**: Filterable list of all tasks across projects

## Redis Configuration

Redis is configured in `config/dev.exs`:

```elixir
config :coding_coordinator, :redis,
  host: "redis.banjo-capella.ts.net",
  port: 443,
  ssl: true,
  database: 0
```

Environment variables for production:
- `REDIS_HOST`
- `REDIS_PORT` (default: 443)
- `REDIS_SSL` (default: "true")
- `REDIS_DATABASE` (default: 0)
- `REDIS_PASSWORD` (optional)

## Development

- Run tests: `mix test`
- Format code: `mix format`
- Compile assets: `mix assets.build`
- Console: `iex -S mix phx.server`

## Production

See [Phoenix Deployment Guides](https://hexdocs.pm/phoenix/deployment.html) for detailed production deployment instructions.

## Learn More

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Tailwind CSS: https://tailwindcss.com/
- Tailwind Plus: https://tailwindcss.com/plus
- Tailwind Plus Downloader: https://github.com/richardkmichael/tailwindplus-downloader
