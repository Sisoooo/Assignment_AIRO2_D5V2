# Irrigation Planning with PDDL

## Problem Description

The scenario models an **autonomous robot tasked with irrigating a field of crops**. The field consists of 6 crops (`c1`–`c6`) arranged in a graph topology, connected by traversable paths, with a depot serving as the robot's starting point.

Each crop has a **moisture level** that must be raised to at least 50 units to be considered adequately irrigated. The robot carries a finite water supply and must navigate the field, prioritize which crops to irrigate, and minimize losses.

### Key Elements

| Element | Description |
|---|---|
| **Robot** | Single autonomous agent that moves between locations and irrigates crops |
| **Crops** | 6 crops with varying initial moisture levels |
| **Depot** | Starting position of the robot |
| **Moisture level** | Numeric value per crop; goal is ≥ 50 for all crops |
| **Water supply** | Finite resource carried by the robot; consumed during irrigation |

---

## Objective

The overarching goal is: **bring all crops to a moisture level ≥ 50, minimizing losses**.

The two formulations differ in how they model time and what "loss" means:

- **Basic PDDL**: Minimize the number of *sacrificed* crops (crops that cannot be irrigated due to water running out).
- **PDDL+**: Minimize a weighted sum of *total time elapsed* and the number of *drought events* (crops that dry out completely below moisture level 10 while the robot is occupied elsewhere).

---

## File Structure

```
Code/
├── Basic_PDDL/
│   ├── Irrigation_basic_domain.pddl       # Basic STRIPS domain
│   ├── Irrigation_problem.pddl            # Full water supply (500 units)
│   └── Irrigation_limited_problem.pddl   # Limited water supply (80 units)
└── PDDL+/
    ├── Irrigation_domain_plus.pddl        # PDDL+ domain with processes & events
    └── Irrigation_problem_plus.pddl       # Problem with evaporation & drought
```

---

## Domain Details

### Basic PDDL Domain (`Irrigation_basic_domain.pddl`)

Uses classical PDDL with numeric fluents. Actions are discrete and instantaneous.

| Action | Description |
|---|---|
| `move` | Move the robot between two connected locations |
| `irrigate` | Add 10 moisture units to a priority crop (costs 10 water) |
| `check_levels` | Re-evaluate crop priority (selects the driest crop) |
| `sacrifice` | Mark a crop as sacrificed when water runs out |

**Problems:**
- `Irrigation_problem.pddl` — robot starts with 500 water units (sufficient to irrigate all crops)
- `Irrigation_limited_problem.pddl` — robot starts with only 80 water units (some crops must be sacrificed)

### PDDL+ Domain (`Irrigation_domain_plus.pddl`)

Extends the model with **continuous processes** and **instantaneous events** to capture real-time dynamics.

| Construct | Description |
|---|---|
| Process `evaporation` | Continuously decreases moisture of non-dried crops over time |
| Process `irrigating_crop` | Continuously increases moisture and consumes water while irrigating |
| Process `moving` | Tracks robot travel progress over time (travel takes 1 time unit) |
| Event `drought` | Triggered when moisture drops below 10 — crop becomes unusable |
| Event `arrive` | Triggered when movement progress reaches 1 — robot arrives at destination |
| Action `choose_target` | Select the driest available crop as the next target |
| Action `start_irrigation` / `stop_irrigation` | Begin/end irrigating a crop |

**Metric:** `minimize (total-time + 1000 × num_drought_events)`

---

## How to Run

- Option 1: PDDL VS Code Extension (for basic PDDL)
- Option 2: Command Line with ENHSP (for PDDL+)

```
java -jar enhsp.jar -o Irrigation_domain_plus.pddl -f Irrigation_problem_plus.pddl -h aibr
```

---

## Initial State Summary

All problems share the same field topology (graph of 6 crops + depot):

```
depot(start1) -- c1 -- c2 -- c3
                  |     |     |
                  c4 -- c5 -- c6
```

| Crop | Initial Moisture |
|---|---|
| c1 | 17 (needs irrigation) |
| c2 | 63 (already irrigated) |
| c3 | 42 (needs irrigation) |
| c4 | 88 (already irrigated) |
| c5 | 5 / 25 (critical) |
| c6 | 71 (already irrigated) |

> Moisture values differ slightly between Basic and PDDL+ problems.
