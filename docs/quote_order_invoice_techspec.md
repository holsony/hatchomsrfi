# Technical Design Specification
## HATCH Delivered Price Quote Calculation (Freight + Margin)

### Author
Holson Yap

### Purpose

Support the HATCH delivered-price quote scenario by allocating freight and margin across quote lines while preserving a simple Quote → Order → Invoice lifecycle.

The solution should:

- Support multi-destination quote lines.
- Support freight allocation across destinations.
- Support margin allocation.
- Present a single delivered price to the customer.
- Avoid Power Automate flows.
- Minimize custom logic.
- Preserve easy mapping into Orders and Invoices.

The HATCH demo requires a delivered-price quote that combines supplier cost, freight estimate, and operating margin and supports multi-destination fulfillment scenarios. 

---

# Business Objective

The food bank should see:

```text
Delivered Price
```

The food bank should NOT see:

```text
Product Cost
Freight Charge
Margin Charge
```

as separate customer-facing lines.

Freight and margin are internal economic drivers used to calculate the delivered price. 

---

# Current Example

## Quote

```text
Central Pennsylvania Food Bank
```

## Quote Lines

```text
Line 1
Large Cage-Free Eggs
10 pallets
Destination: Harrisburg

Line 2
Large Cage-Free Eggs
8 pallets
Destination: Chester County
```

## Demo Assumptions

```text
18 pallets = 16,200 dozen

900 dozen per pallet

Supplier Cost:
$1.36 per dozen

Freight Estimate:
$1,550

Margin:
$0.05 per dozen
```

Based on the demo script requirements. 

---

# Recommended Data Model

## Entity

```text
quotedetail
```

(Quote Product)

## New Fields

| Field | Type | Description |
|---------|---------|---------|
| new_suppliercostamount | Currency | Supplier cost for this quote line |
| new_freightallocation | Currency | Allocated freight for this quote line |
| new_marginamount | Currency | Margin allocated to this quote line |

---

# OOB Fields Used

Use standard Dynamics pricing fields:

```text
priceperunit
quantity
baseamount
extendedamount
```

No modification to OOB pricing calculations.

---

# Calculation Model

## Delivered Value

```text
Delivered Value =
Supplier Cost
+ Freight Allocation
+ Margin
```

## Price Per Unit

```text
Price Per Unit =
Delivered Value
÷ Quantity
```

The plugin updates:

```text
quotedetail.priceperunit
```

Dynamics 365 then calculates:

```text
Extended Amount =
Quantity × Price Per Unit
```

using standard platform behavior.

---

# Example Calculation

## Harrisburg

```text
10 pallets
```

Supplier Cost:

```text
10 × 900 × $1.36
=
$12,240
```

Freight Allocation:

```text
$1,550 × (10 / 18)
=
$861.11
```

Margin:

```text
9,000 dozen × $0.05
=
$450
```

Delivered Value:

```text
$12,240
+ $861.11
+ $450
=
$13,551.11
```

Price Per Unit:

```text
$13,551.11 ÷ 10
=
$1,355.11
```

Stored in:

```text
priceperunit
```

---

# Plugin Recommendation

## Plugin Type

```text
Dataverse Plugin
```

## Trigger

```text
quotedetail
```

### Events

```text
Create
Update
```

### Trigger Fields

```text
quantity

new_suppliercostamount
new_freightallocation
new_marginamount
```

---

# Plugin Behavior

```text
1. Read Quantity

2. Read Supplier Cost

3. Read Freight Allocation

4. Read Margin Amount

5. Calculate Delivered Value

6. Calculate Price Per Unit

7. Update:
   priceperunit

8. Allow standard D365 pricing engine
   to calculate:
   baseamount
   extendedamount
```

---

# Freight Allocation Button

## Command Bar Button

```text
Allocate Freight & Margin
```

## Behavior

Button executes JavaScript.

JavaScript:

```text
1. Read Quote Freight Estimate

2. Retrieve Quote Lines

3. Calculate total pallet quantity

4. Allocate freight proportionally

5. Allocate margin

6. Update:

   new_freightallocation
   new_marginamount

7. Save Quote Lines
```

Plugin performs final pricing calculation.



---

# Mapping Strategy

Create the same fields on:

```text
quotedetail
salesorderdetail
invoicedetail
```

| Quote | Order | Invoice |
|---------|---------|---------|
| new_suppliercostamount | new_suppliercostamount | new_suppliercostamount |
| new_freightallocation | new_freightallocation | new_freightallocation |
| new_marginamount | new_marginamount | new_marginamount |

Map values during:

```text
Quote → Order

Order → Invoice
```

No downstream recalculation required.

---

# Customer Experience

Seller sees:

```text
Supplier Cost:      $12,240.00
Freight:               861.11
Margin:                450.00
------------------------------
Delivered Value:   $13,551.11
```

Customer sees:

```text
Quantity
Price Per Unit
Extended Amount
```

Result:

```text
Simple delivered-price quote
```

without exposing freight as a separate charge. 【2-85fe9b】【1-e9e85b】

---

# Final Recommendation

Use:

```text
3 custom currency fields

+
1 lightweight Quote Product plugin

+
1 command bar button
```

Avoid:

```text
Power Automate

Tax field repurposing

Freight products

Margin products

Complex pricing engine customization
```

This provides the smallest implementation footprint, the easiest demo experience, and the cleanest Quote → Order → Invoice propagation path while aligning to the HATCH delivered-price quoting model. 