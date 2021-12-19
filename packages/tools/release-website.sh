#!/bin/bash

set -e

# ------------------------------------------------------------------------------
# Setup environment
# ------------------------------------------------------------------------------

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME=`basename "$0"`
JOPLIN_ROOT_DIR="$SCRIPT_DIR/../.."
JOPLIN_WEBSITE_ROOT_DIR="$JOPLIN_ROOT_DIR/../joplin-website"

# ------------------------------------------------------------------------------
# Update the Markdown files inside the Joplin directory. This is for example the
# download links README.md or the desktop app changelog.
# ------------------------------------------------------------------------------

cd "$JOPLIN_ROOT_DIR"

# Will fail if there's any local change in the repo, which is what we want
git pull --rebase 

npm install

# Clean up npm's mess
git reset --hard

npm run updateMarkdownDoc

# We commit and push the change. It will be a noop if nothing was actually
# changed

git add -A

git commit -m "Doc: Updated Markdown files

Auto-updated using $SCRIPT_NAME"

git push

# ------------------------------------------------------------------------------
# Build and deploy the website
# ------------------------------------------------------------------------------

cd "$JOPLIN_WEBSITE_ROOT_DIR"
git pull --rebase

cd "$JOPLIN_ROOT_DIR"
npm run buildWebsite

cd "$JOPLIN_WEBSITE_ROOT_DIR"
git add -A
git commit -m "Updated website

Auto-updated using $SCRIPT_NAME"
git push