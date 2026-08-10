#!/usr/bin/env bash
set -euo pipefail

echo "PAC version:"
pac | head -n 3

echo "\nAuth profiles:"
pac auth list

echo "\nCurrent org:"
pac org who
