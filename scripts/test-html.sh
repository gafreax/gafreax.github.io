#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Minimal HTML & Assets Quality / Regression Test Script
# Zero external heavy frameworks: uses bash, grep, and file checks.
# ==============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

PASS_COUNT=0
FAIL_COUNT=0

log_pass() {
  echo -e "\033[0;32m✓ PASS:\033[0m $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

log_fail() {
  echo -e "\033[0;31m✗ FAIL:\033[0m $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

echo "=== Running Minimal HTML & Asset Verification in $PROJECT_DIR ==="

# 1. Check Core Asset Files
for asset in "style.css" "main.js" "index.html" "article-container-at-war.html"; do
  if [[ -f "$asset" ]]; then
    log_pass "File exists: $asset"
  else
    log_fail "Missing essential file: $asset"
  fi
done

# 2. Check HTML Semantic Structure
check_html_file() {
  local file="$1"
  echo "--- Checking semantic requirements in $file ---"

  if grep -qi "<!DOCTYPE html>" "$file"; then
    log_pass "$file has valid <!DOCTYPE html>"
  else
    log_fail "$file is missing <!DOCTYPE html>"
  fi

  if grep -qi '<meta name="viewport"' "$file"; then
    log_pass "$file has responsive viewport meta tag"
  else
    log_fail "$file is missing viewport meta tag"
  fi

  if grep -qi "<title>" "$file"; then
    log_pass "$file has a <title> element"
  else
    log_fail "$file is missing <title>"
  fi

  # Exactly one <h1> per page for accessibility and SEO
  local h1_count
  h1_count=$(grep -o -i "<h1" "$file" | wc -l)
  if [[ "$h1_count" -eq 1 ]]; then
    log_pass "$file has exactly 1 <h1> heading"
  else
    log_fail "$file expected 1 <h1> heading, found $h1_count"
  fi

  if grep -qi "<main" "$file"; then
    log_pass "$file contains <main> landmark"
  else
    log_fail "$file missing <main> landmark"
  fi

  if grep -qi "<header" "$file" && grep -qi "<footer" "$file"; then
    log_pass "$file contains <header> and <footer> landmarks"
  else
    log_fail "$file missing header or footer landmarks"
  fi
}

check_html_file "index.html"
check_html_file "article-container-at-war.html"

# 3. Check Internal Links
echo "--- Checking Internal Links in HTML files ---"
check_internal_links() {
  local file="$1"
  # Extract local hrefs matching *.html
  local links
  links=$(grep -oE 'href="[a-zA-Z0-9_\.\-]+\.html(#?[a-zA-Z0-9_\-]*)?"' "$file" | sed 's/href="//;s/"//' || true)

  for link in $links; do
    local target_file
    target_file=$(echo "$link" | cut -d'#' -f1)
    if [[ -n "$target_file" ]]; then
      if [[ -f "$target_file" ]]; then
        log_pass "$file -> Link target exists: $target_file"
      else
        log_fail "$file -> Broken link target: $target_file"
      fi
    fi
  done
}

check_internal_links "index.html"
check_internal_links "article-container-at-war.html"

# 4. Check CSS custom properties existence
echo "--- Checking CSS Theme Variables in style.css ---"
for var in "--bg:" "--text-primary:" "--font-display:" "--font-mono:" '[data-theme="dark"]'; do
  if grep -qF -e "$var" "style.css"; then
    log_pass "style.css defines: $var"
  else
    log_fail "style.css missing definition: $var"
  fi
done

# 5. Summary
echo "================================================="
echo "TOTAL: Passed: $PASS_COUNT | Failed: $FAIL_COUNT"
if [[ "$FAIL_COUNT" -gt 0 ]]; then
  echo "Validation failed!"
  exit 1
else
  echo -e "\033[0;32mAll HTML & Asset tests passed successfully!\033[0m"
  exit 0
fi
