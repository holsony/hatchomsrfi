# HATCH OMS RFI — Demo Build

This project is set up to manage the HATCH Order Management System (OMS) RFI demo Power Platform environment and related Dataverse assets using PAC CLI.

## Target Environment

- Environment URL: `https://generaldemosl.crm.dynamics.com`
- Tenant domain: `slalombizapps.onmicrosoft.com`

## Prerequisites

- PAC CLI installed (`pac`)
- Permission to sign into the target tenant/environment

## Quick Start

1. Connect PAC to the environment:

   ```bash
   ./scripts/pac-connect.sh
   ```

2. Verify profile and current org:

   ```bash
   ./scripts/pac-check.sh
   ```

3. Optionally set the created profile as active:

   ```bash
   pac auth select --name HATCHRFIDemo
   ```

## Useful Commands

- List auth profiles: `pac auth list`
- Current environment: `pac org who`
- List solutions: `pac solution list`

## Notes

- `pac auth create` may open a browser sign-in flow.
- If prompted for credentials, complete sign-in with your authorized account.
- RFI requirements/notes from the HATCH OMS RFI notebook should be added under `notes/` once available.

## TODO

- [ ] Add HATCH OMS RFI requirements/scope (paste from Copilot notebook)
- [ ] Confirm target solution name and app(s) to build
- [ ] Confirm required Dataverse entities/tables for the OMS demo
