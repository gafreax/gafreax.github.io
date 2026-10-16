#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Screenshot Generation Script
# Uses headless Google Chrome to capture high-res desktop and mobile previews.
# ==============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${PROJECT_DIR}/screenshots"

mkdir -p "$OUTPUT_DIR"

echo "=== Generating Screenshots in ${OUTPUT_DIR} ==="

CHROME_BIN="google-chrome"
if ! command -v "$CHROME_BIN" &>/dev/null; then
  echo "Error: google-chrome not found in PATH."
  exit 1
fi

take_shot() {
  local url="$1"
  local output_name="$2"
  local width="$3"
  local height="$4"

  echo "Capturing [${width}x${height}]: ${output_name}..."
  "$CHROME_BIN" \
    --headless=new \
    --hide-scrollbars \
    --window-size="${width},${height}" \
    --screenshot="${OUTPUT_DIR}/${output_name}" \
    "$url" >/dev/null 2>&1
}

# 1. Index Page - Desktop (1440x1100)
take_shot "file://${PROJECT_DIR}/index.html?theme=light" "index-desktop-light.png" 1440 1100
take_shot "file://${PROJECT_DIR}/index.html?theme=dark" "index-desktop-dark.png" 1440 1100

# 2. Index Page - Mobile (400x950)
take_shot "file://${PROJECT_DIR}/index.html?theme=light" "index-mobile-light.png" 400 950
take_shot "file://${PROJECT_DIR}/index.html?theme=dark" "index-mobile-dark.png" 400 950

# 3. Article Page - Desktop (1440x1100)
take_shot "file://${PROJECT_DIR}/article-container-at-war.html?theme=light" "article-desktop-light.png" 1440 1100
take_shot "file://${PROJECT_DIR}/article-container-at-war.html?theme=dark" "article-desktop-dark.png" 1440 1100

# 4. Article Page - Mobile (400x950)
take_shot "file://${PROJECT_DIR}/article-container-at-war.html?theme=light" "article-mobile-light.png" 400 950

echo "=== All screenshots successfully captured in ${OUTPUT_DIR} ==="
ls -lh "${OUTPUT_DIR}"
