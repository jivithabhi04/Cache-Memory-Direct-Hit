# Direct-Mapped Cache Memory Controller — Verilog

A hardware implementation of a direct-mapped cache memory controller
built in Verilog, designed as a resume project demonstrating digital
hardware design methodology.

---

## What This Project Does

Simulates the hit/miss detection mechanism of a direct-mapped cache.
When a CPU requests a memory address, the controller checks whether
the data is already in cache (hit) or not (miss). No write-back or
dirty bit logic is included — this is a focused read-only hit/miss
detector.

---

## Address Format (4-bit)

| Bits | Field       | Size   | Purpose                        |
|------|-------------|--------|-------------------------------|
| [3:2]| Tag         | 2 bits | Identifies the memory block    |
| [1]  | Block number| 1 bit  | Selects cache block (0 or 1)   |
| [0]  | Byte offset | 1 bit  | Selects byte within the block  |

---

## Architecture

The design is split into two units following standard hardware
design methodology:

**Datapath** — built structurally by instantiating:
- 1-bit 2-to-1 MUX (gate level: AND, OR, NOT)
- 2-bit 2-to-1 MUX (two 1-bit MUXes instantiated)
- 2-bit equality comparator (gate level: XNOR + AND)
- Tag directory (two 2-bit registers, one per cache block)

**Controller (FSM)** — a 4-state Moore machine:
- IDLE → waits for read request
- COMPARE → enables MUX and comparator
- HIT → asserts hit_out for one clock cycle
- MISS → asserts miss_out for one clock cycle

---

## File Structure
```
cache_controller_project.v   — all modules + testbench in one file
│
├── mux2to1_1bit             — 1-bit MUX (gate level)
├── mux2to1_2bit             — 2-bit MUX (structural)
├── comparator_2bit          — equality comparator (gate level)
├── tag_register_2bit        — single tag directory slot
├── cache_datapath           — structural datapath
├── cache_controller         — FSM controller
├── cache_top                — top-level connection
└── cache_tb                 — testbench
```

---

## How to Simulate

1. Go to [https://edaplayground.com](https://edaplayground.com)
2. Paste the contents of `cache_controller_project.v`
3. Select **Icarus Verilog** as the simulator
4. Set top module to `cache_tb`
5. Click Run

**Expected output:**
```
Test 1 | addr=1010 | tag=10 blk=1 | hit=0 miss=1 | Cold start: MISS expected
Test 2 | addr=1010 | tag=10 blk=1 | hit=1 miss=0 | Repeat same addr: HIT expected
Test 3 | addr=0110 | tag=01 blk=1 | hit=0 miss=1 | Different tag same block: MISS expected
Test 4 | addr=0100 | tag=01 blk=0 | hit=0 miss=1 | Block 0 cold start: MISS expected
Test 5 | addr=0100 | tag=01 blk=0 | hit=1 miss=0 | Block 0 repeat: HIT expected
```

---

## Key Design Decisions

- **Structural over behavioral** — every datapath component is built
  from gate primitives to demonstrate gate-level understanding
- **Datapath and control separation** — FSM only generates control
  signals; no logic is mixed between the two units
- **Moore machine** — outputs depend only on current state, not inputs,
  making the design clean and predictable
- **Scalable** — changing to a 32-bit address only requires widening
  the tag field and adding more cache blocks; the core logic is identical

---

## Concepts Demonstrated

- Direct-mapped cache addressing (tag / index / offset)
- Structural Verilog and gate-level instantiation
- Algorithmic State Machine (ASM) chart → state diagram → FSM → Verilog
- Datapath and control unit separation
- Moore FSM design and implementation

---

## Background

Built as part of self-study in Computer Organization and Architecture.
Targeted at understanding how cache hardware actually works at the
gate level, beyond textbook diagrams.
