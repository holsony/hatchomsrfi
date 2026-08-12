# HATCH CRM/OMS Demo Build - GitHub Copilot Instructions

## Purpose
Use this file to keep GitHub Copilot and MCP-driven changes grounded in the HATCH demo build intent. The goal is a clean, simple, CE-first Release 1 demo for HATCH for Hunger. Do not infer beyond the source files. If a request is unclear, ask for clarification before building.

## Authoritative Source Files
When making demo-build changes, read these files first:

1. `docs/HATCH_CRM_OMS_Demo_Build_Tracker_CE_Only_PoV.xlsx`
   - Use the `Demo Build Tracker` sheet as the backlog.
   - Treat the `Demo build (CE-only PoV: CE / Power Platform / CI-J / TMS)` column as the implementation lens.
   - Treat column `I` / `Questions for Molly` as raw clarification notes. Do not convert unclear notes into build scope unless they are explicit.
   - Use the `Hero Records` sheet for sample values.

2. `docs/HATCH script _ high level walkthrough with Molly.docx`
   - Use this transcript to resolve ambiguity from the tracker.
   - If the transcript says something is uncertain or should be confirmed, do not implement it as a hard requirement.

3. `docs/HATCH_CRM_OMS_120_Minute_Demo_Script_Vendor.docx`
   - Use this as the demo scenario contract.
   - The demo must follow the five scenarios and expected evidence without adding unrelated scope.

4. `docs/HATCH_CRM_OMS_RFI_Document.docx`
   - Use this for architecture intent and system-of-record boundaries.

## Non-Negotiable Demo Stance
- Release 1 demo is CE-first: Dynamics 365 Sales / Dataverse + Power Platform + Customer Insights - Journeys or external marketing + TMS integration/mock + QuickBooks handoff + Power BI.
- Do not build F&O or Dual-Write demo functionality unless explicitly requested later.
- Do not introduce F&O as an order master in this demo.
- Dataverse/CE owns customer-facing CRM and commercial order orchestration for the demo.
- TMS owns freight execution concepts: freight estimate, shipment creation, carrier status, ETA, delay events, POD, and delivery variance events.
- QuickBooks is the Phase 1 finance handoff target; only mock/payload/status evidence is needed unless explicitly requested.

## Design Principles
- Keep the demo simple, clean, and low-friction for a small team.
- Prefer standard D365/Dataverse behavior where it is enough for the demo.
- Use custom Dataverse tables only where the demo needs a clear concept that is not well represented by standard tables.
- Minimize data-entry burden and avoid over-customization.
- When showing AI, keep it limited to standard, simple, out-of-the-box value. Do not over-AI the demo.
- User experience matters: show the end-user flow first; only explain configuration when it proves a point.

## Vocabulary and Naming
- Use “Pre-Order” as the demo-friendly label for Opportunity where possible.
- Use “Delivered Price Quote” language for quotes.
- Use “Commercial Order” for the customer-facing order record created from accepted quote / PO.
- Do not rename entities based on guesses. If renaming requires solution customization, confirm first.

## Hero Scenario Data
Use the workbook hero records and demo script values unless the user provides a newer data file:

- Account: Central Pennsylvania Food Bank
- Primary contact: Jordan Lee, Director of Procurement
- Territory / owner: Mid-Atlantic / Whitney Murphy
- Funding context: Pennsylvania PASS eligible; current-year funding expires June 30
- Product: Large cage-free eggs
- Requested quantity: 18 pallets / 16,200 dozen
- Supplier cost: $1.36 per dozen
- Operating margin target: $0.05 per dozen
- Origin: Lancaster, Pennsylvania
- Destination 1: Harrisburg, Pennsylvania - 12 pallets
- Destination 2: Chester County, Pennsylvania - 6 pallets
- Delivery window: Tuesday, 8:00 AM-2:00 PM
- TMS freight estimate: $1,550 consolidated refrigerated full truckload
- Temperature requirement: Refrigerated; configurable handling instructions
- Customer PO: CPFB-0726-1842
- Execution exception: Carrier reports a four-hour delay and revised ETA
- Delivery outcome: 17 pallets delivered; one pallet rejected for damage
- Finance handoff: invoice-ready after POD and quantity variance review

## Account and Address Modeling Rules
- Central Pennsylvania Food Bank is one customer account.
- Do not model Central Penn warehouses or partner hubs as separate Account records.
- Model Central Penn delivery locations as customer addresses or delivery-location child records.
- Most food banks can be assumed to have one location unless demo data explicitly provides multiple.
- Contacts should remain standard food-bank contacts unless explicitly asked to model volunteers or special contact roles.
- Do not build volunteer management for this demo.

## Opportunity / Pre-Order Rules
- Current HATCH demand is generally eggs or other protein, not complex mixed-product opportunities.
- For the demo, assume a pre-order is usually for one primary product type unless explicitly told otherwise.
- Chicken eggs only; do not add duck, quail, or other egg types.
- Product preferences should be lightweight visibility into order history/preferences, not a complex recommendation engine.
- Funding source/notes can be free text unless a specific field model is provided.
- Expected order date means expected ship date.
- Requested delivery window means when the food bank needs the product delivered.
- Food bank capacity can be free text for demo purposes, such as receiving or storage constraints.
- Next action should relate to the pre-order progression, from demand identified through converted to order.
- Territory demo can show assignment to a person and visibility/coverage by territory; do not overbuild territory hierarchy unless requested.

## Quote and Pricing Rules
- Quote must support delivered price: product cost + allocated freight + operating margin.
- Freight should not appear as a separate line item on the customer-facing food-bank quote unless explicitly requested.
- Allocate freight across product quantity so the food bank sees one all-in product price.
- Supplier/farm selection can be represented as a simple lookup or demo field; do not build complex vendor matching unless requested.
- Procurement/farm availability is manual today; do not claim automated optimization unless explicitly built as a mock.
- Margin approval should be simple and email-friendly for the demo.
- Teams approvals can be a talk track unless explicitly requested.
- Customer-ready quote output can be simple: header, lines, terms, and email/logged communication.
- Use quote revisions/version history where standard D365 behavior supports it.

## PO, Order, and Invoice Rules
- Do not overbuild a separate PO subsystem unless requested.
- For this demo, PO can be represented as captured order/quote information sufficient to show quote acceptance becoming an order and official customer PO/confirmation.
- Avoid rekeying: quote should become order with copied customer, product, pricing, and quantity context.
- Duplicate PO detection, missing-field checks, unusual quantity, and price warnings should be rules-based. Do not use machine learning unless explicitly requested.
- Commercial Order is the customer-facing order record.
- Order dashboard should show statuses such as pending, active, exception, delivered, and invoice-ready.

## Split Delivery / Order Destination Rules
- Use an Order Destination / Stop child table or equivalent child records under Commercial Order.
- Preserve one customer-facing commercial relationship while showing multiple destinations.
- For the demo, one order can have two destinations with pallets, delivery window, contact, and instructions.
- If modeling a farm-side purchase linked to multiple food-bank pre-orders is requested, ask before building; this was discussed but not fully designed.

## TMS Mock / Transportation Rules
- It is acceptable and preferred to create a visible mock integration rather than only talk track it.
- Provide a button/flow/API mock that sends order release context and receives mock TMS responses, if feasible.
- Release payload should include origin, destinations, product, quantity, temperature, dates, references, and special instructions.
- Shipment response should include shipment ID, carrier, booked cost, pickup status, ETA, and tracking events.
- Four-hour delay is an in-transit status update, not a waiting period before routing.
- Delay handling should show revised ETA, alert routing, ownership, customer communication task/email, and timeline history.

## POD, Variance, and QuickBooks Handoff Rules
- POD means Proof of Delivery.
- POD is assumed to be uploaded by the carrier/TMS and sent back to CRM/OMS.
- POD/delivery details should update actual delivered quantities and support invoice-ready logic.
- In the demo scenario: 18 pallets ordered, 17 delivered, 1 rejected for damage.
- Do not keep the order open for one remaining pallet unless explicitly requested.
- For the demo, close/reconcile to the actual delivered quantity and invoice for 17 pallets.
- QuickBooks handoff can be mocked as a payload/status update after POD and variance review.

## Marketing / Customer Insights - Journeys Rules
- Keep marketing lightweight.
- The core marketing value is connected account, sales, pre-order, and order data for segmentation and attribution.
- Demonstrate simple segmentation and a simple journey/email concept if requested.
- Do not build complex marketing automation unless explicitly requested.
- HubSpot can be referenced as an external option, but show Microsoft Customer Insights - Journeys if building a Microsoft-stack demo.
- Emphasize list reduction, opt-in/opt-out/compliance, and connected CRM data rather than sophisticated journey design.

## Reporting and Power BI Rules
- Power BI is important because HATCH already uses Power BI heavily for reporting.
- Build simple demo dashboards only where they support the scenarios: pipeline, forecast, account health, quote conversion, open orders, exceptions, margin, user adoption, and invoice-ready status.
- Do not invent highly specific HATCH KPIs unless provided in source data or explicitly requested.
- Mock dashboard data is acceptable if clearly demo/sample data.

## Security, Auditing, and Admin Rules
- Show basic role-based views for seller, operations, finance, sales manager, and admin if needed.
- Finance can be read-only where appropriate unless a workflow requires update capability.
- Enable or demonstrate audit history for price, quantity, margin, PO, and order status changes.
- Workflow changes by a business admin should be basic, such as changing an alert threshold or email routing rule.
- Do not build a sophisticated rule engine unless explicitly requested.

## Implementation / Commercial Discussion Rules
- Demo session should focus on scenario proof points, not detailed pricing discussion.
- Pricing can be a follow-up or slide/talk track.
- Microsoft nonprofit program details may be a short intro/talk track, but do not hardcode unverified pricing or discounts into the app.
- Do not create implementation timeline claims unless the source includes them or the user supplies them.

## Build Guardrails for GitHub Copilot
When changing code, configuration files, seed data, or MCP scripts:

1. Read the relevant source file first.
2. Point to the tracker row or transcript basis in comments or README notes when implementing a demo feature.
3. Do not add features just because they are plausible.
4. Do not infer missing table schemas, choice values, relationships, or business rules without checking existing Dataverse metadata or asking the user.
5. Do not create new Dataverse tables if an existing standard table or already-created custom table exists.
6. Do not delete existing records unless the user explicitly asks.
7. Do not create Central Penn partner accounts.
8. Do not create F&O/Dual-Write artifacts.
9. Do not implement complex AI/agent experiences unless explicitly requested.
10. If uncertain, stop and ask the user one clear question.

## Preferred Output for Build Tasks
For each build task, return:

- What changed
- Files changed
- Dataverse tables/columns touched
- Records created or updated
- Assumptions used
- Items intentionally not implemented because source data was unclear
- Any next question for the user

## Default Question When Requirements Are Ambiguous
If a requirement can be interpreted multiple ways, ask:

"I found multiple possible interpretations in the HATCH tracker/transcript. Should I implement the simplest CE/Dataverse demo version, or do you want a more complete custom model?"
