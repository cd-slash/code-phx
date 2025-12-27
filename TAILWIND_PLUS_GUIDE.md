# Tailwind Plus Components Guide

This guide explains how to use the Tailwind Plus components in the Coding Coordinator project.

## Files

- **tailwindplus-components-2025-12-26-154935.json** (321MB) - Full components with all code
- **tailwindplus-index.json** (116KB) - Component index (categories, paths, names)
- **tailwindplus-skeleton.json** (2.9MB) - Skeleton with structure and truncated content

## Using with LLM Assistants

### Option 1: Use Index File (Recommended for Most LLMs)

The 116KB index file contains all component names and paths. You can provide this to an LLM as context.

**Example prompt:**
```
I have Tailwind Plus components available. Here's the component index:
[Contents of tailwindplus-index.json]

I need a hero section for a coding coordinator dashboard. Please find a suitable component.
```

### Option 2: Use Helper Script

Search and extract components using the helper script:

```bash
# Search for components
./tailwindplus-helper.sh hero

# Get full HTML for a component
./tailwindplus-helper.sh --code "With background image hero and pricing section"
```

### Option 3: Use jq Directly

Search for components:
```bash
jq -r '.tailwindplus[][][][] | select(.name | ascii_downcase | contains("hero" | ascii_downcase)) | "\(.name)"' tailwindplus-components-2025-12-26-154935.json
```

Get HTML for a specific component (Tailwind v4, HTML format):
```bash
jq -r --arg name "Simple centered" '
    .tailwindplus[][][][] |
    select(.name == $name) |
    .snippets[] |
    select(.name == "html" and .version == 4) |
    .code
' tailwindplus-components-2025-12-26-154935.json
```

## Component Structure

Each component has multiple formats and variations:

```json
{
  "Simple centered": {
    "name": "Simple centered",
    "snippets": [
      {
        "code": "<div>...</div>",
        "language": "html",
        "mode": "light",
        "name": "html",
        "preview": "<!doctype html>...",
        "supportsDarkMode": true,
        "version": 4
      },
      {
        "code": "<div class=\"dark:...\",
        "language": "html",
        "mode": "dark",
        "name": "html",
        "preview": "...",
        "supportsDarkMode": true,
        "version": 4
      }
    ]
  }
}
```

- **version**: 3 or 4 (Tailwind CSS version)
- **language**: html, jsx (React), vue
- **mode**: light, dark, system
- **supportsDarkMode**: Whether dark mode variation is available

## Available Categories

1. **Application UI**
   - Application Shells
   - Headings
   - Data Display
   - Lists
   - Forms
   - Feedback

2. **Marketing**
   - Page Sections
     - Hero Sections
     - Feature Sections
     - CTA Sections
     - etc.
   - Page Examples
   - Feedback
   - Elements

3. **Ecommerce**
   - Product Grids
   - Product Details
   - Cart
   - Checkout
   - etc.

## Integrating with Phoenix LiveView

When you find a component, you can adapt it for Phoenix LiveView:

### Example: Hero Section

1. **Extract HTML** (light mode, Tailwind v4):
```bash
./tailwindplus-helper.sh --code "Simple centered"
```

2. **Convert to HEEX**:

Original (Tailwind Plus HTML):
```html
<a href="#" class="text-sm/6 font-semibold text-white">Log in <span aria-hidden="true">&rarr;</span></a>
```

Convert to Phoenix HEEX:
```heex
<.link navigate="/login" class="text-sm/6 font-semibold text-white">
  Log in <span aria-hidden="true">&rarr;</span>
</.link>
```

3. **Handle Tailwind Elements**:

Some components use Tailwind Elements (`<el-dialog>`, `<el-dropdown>`). Replace these with daisyUI components or vanilla JavaScript equivalents.

Example replacement:
```html
<!-- Tailwind Plus -->
<el-dialog>
  <dialog id="mobile-menu">...</dialog>
</el-dialog>

<!-- With daisyUI -->
<dialog class="modal">...</dialog>
```

## Working with Opencode

When using Opencode or Claude Code:

1. **Share the index file** first so it knows available components
2. **Ask for component recommendations**: "Find a hero section suitable for a dashboard"
3. **Request integration**: "Adapt this component for Phoenix LiveView in `lib/coding_coordinator_web/live/dashboard_live.ex`"

The tool can use the `tailwindplus-helper.sh` script to extract component code as needed.

## Dark Mode

Tailwind Plus provides separate light and dark mode snippets. For Phoenix LiveView:

```heex
<div class="bg-gray-900 dark:bg-gray-100">
  <!-- Use tailwind's dark mode prefix -->
</div>
```

Or use daisyUI's theme system:
```html
<html data-theme="dark">
```

## Best Practices

1. **Always use Tailwind v4** components (version: 4)
2. **Prefer HTML format** over React/Vue for Phoenix
3. **Check for dark mode support** if your app uses it
4. **Replace Tailwind Elements** with daisyUI equivalents
5. **Convert links** to Phoenix `.link` or `<.link>` components
6. **Use LiveView event handlers** instead of JavaScript where possible

## Common Components for Dashboard

Good starting points for the Coding Coordinator:

- **Hero Sections**: Marketing/Page Sections/Hero Sections
- **Stats/Data Display**: Application UI/Data Display/Stats
- **Tables**: Application UI/Lists/Tables
- **Cards**: Application UI/Data Display
- **Forms**: Application UI/Forms
- **Navigation**: Application UI/Application Shells

## Updating Components

Tailwind Plus updates frequently. To get the latest:

```bash
# Download latest components
npx github:richardkmichael/tailwindplus-downloader#latest

# This creates a new timestamped file: tailwindplus-components-YYYY-MM-DD-HHMMSS.json
```

Update the `COMPONENTS_FILE` variable in `tailwindplus-helper.sh` to point to the new file.

## Troubleshooting

**Component not found**:
- Check exact component name (case-sensitive)
- Use search to find similar names: `./tailwindplus-helper.sh <search-term>`

**Dark mode not working**:
- Ensure your theme configuration includes dark mode support
- Check if component has `supportsDarkMode: true`

**Tailwind Elements not rendering**:
- Replace with daisyUI components
- Or install `@tailwindplus/elements` via npm if needed

## Resources

- Tailwind Plus: https://tailwindcss.com/plus
- Tailwind Plus Downloader: https://github.com/richardkmichael/tailwindplus-downloader
- daisyUI: https://daisyui.com/
- Phoenix LiveView: https://hexdocs.pm/phoenix_live_view
