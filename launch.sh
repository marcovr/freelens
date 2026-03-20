#!/usr/bin/env bash

export FREELENS_NAMESPACE_AUTHORIZATION_CHECK=false
export FREELENS_METRICS_CHECK=false

nix-shell --command "pnpm install && pnpm build && pnpm build:app:dir" && nix-shell --command "pnpm start"
