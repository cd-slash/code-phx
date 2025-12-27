#!/bin/bash

# Tailwind Plus Component Helper Script
# Usage: ./tailwindplus-helper.sh [query]

COMPONENTS_FILE="tailwindplus-components-2025-12-26-154935.json"

if [ -z "$1" ]; then
    echo "Usage: $0 <query>"
    echo ""
    echo "Examples:"
    echo "  $0 hero"
    echo "  $0 button"
    echo "  $0 \"Simple centered\""
    echo ""
    echo "To get HTML code for a specific component:"
    echo "  $0 --code \"Simple centered\""
    exit 1
fi

if [ "$1" == "--code" ]; then
    if [ -z "$2" ]; then
        echo "Usage: $0 --code <component-name>"
        exit 1
    fi

    echo "Searching for component: $2"
    echo ""

    jq -r --arg name "$2" '
        .tailwindplus[][][][] |
        select(.name == $name) |
        .snippets[] |
        select(.name == "html" and .version == 4) |
        .code
    ' "$COMPONENTS_FILE"

else
    echo "Searching for components matching: $1"
    echo ""

    jq -r --arg search "$1" '
        .tailwindplus[][][][] |
        select(.name | ascii_downcase | contains($search | ascii_downcase)) |
        "\(.name)"
    ' "$COMPONENTS_FILE" | head -20

    echo ""
    echo "Found components. Use --code flag to get full HTML:"
    echo "  $0 --code \"<component-name>\""
fi
