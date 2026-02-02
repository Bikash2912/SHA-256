# SHA-256

# Iterative SHA-256 ASIC Implementation (RTL → Gate-Level)

## Overview
This project implements the **SHA-256 cryptographic hash algorithm** using an **iterative hardware architecture**, written in **Verilog HDL** and targeted for **ASIC-style design flow**.

The focus of this work is not only functional correctness, but also **architectural decision-making, control–datapath design, verification rigor, and synthesis readiness**, following how real ASIC frontend designs are developed and handed off to backend teams.

The design is:
- Fully verified using standard SHA-256 test vectors
- Debugged at **round-by-round granularity**
- Synthesized to a **gate-level netlist** using Yosys
- Structured to be **backend-ready** for physical design

---

## Why Iterative SHA-256?
SHA-256 can be implemented in multiple architectural styles. This project intentionally uses an **iterative (single-round reused) architecture** to study and demonstrate **area-efficient design trade-offs**.

### Architectural intent:
- **One round per clock cycle**
- **Hardware reuse across 64 rounds**
- Lower area and power compared to fully unrolled or deeply pipelined designs
- Deterministic control using a finite state machine (FSM)

This style is commonly preferred in **resource-constrained ASICs**, secure microcontrollers, and embedded cryptographic accelerators.

---

## Architecture Summary

### High-level blocks
- **Control FSM**  
  Manages initialization, round progression (0–63), and completion signaling.
- **Datapath (A–H registers)**  
  Implements the SHA-256 working variables and feed-forward logic.
- **Round Function**  
  Implements Σ0, Σ1, Ch, Maj, and the main compression logic.
- **Message Scheduler**  
  Generates W[t] words using a 16-word sliding window.
- **Round Counter**  
  Tracks exactly 64 compression rounds.

The design cleanly separates **control** and **datapath**, which simplifies verification and makes the netlist backend-friendly.

---

## Verification Strategy

Verification was treated as a **core part of the project**, not an afterthought.

### What was verified:
- Correct message padding and block formatting
- Exact **64-round execution**
- Intermediate A–H values matched against known SHA-256 references
- Final hash verified using the standard `"abc"` test vector

### Debug approach:
- Cycle-accurate waveform inspection
- Round-by-round logging of:
  - W[t]
  - K[t]
  - A–H registers
  - T1 and T2 values
- Identified and fixed subtle FSM timing and datapath feed-forward issues

This ensured **functional correctness before synthesis**, which is essential in real ASIC workflows.

---

## Synthesis and Gate-Level Results

The verified RTL was synthesized using **Yosys**, producing a **technology-mapped gate-level netlist**.

### What the gate-level netlist represents:
- Exact hardware realization of the design
- Explicit flip-flops and combinational logic
- Formal handoff point between **frontend (RTL)** and **backend (physical design)**

### What can be analyzed at gate level:
- Flip-flop count (sequential area proxy)
- Logic complexity (combinational area proxy)
- Critical combinational paths (timing awareness)
- Backend readiness (single clock, no latches, clean resets)

This is a **natural stopping point for ASIC frontend engineers**, and a standard boundary in industry flows.

---

## Practical Learnings from This Project

This project provided hands-on understanding of:

- Control–datapath partitioning
- FSM-driven iterative architectures
- Cryptographic hardware design
- Round-by-round functional debugging
- Importance of verification before synthesis
- Area vs throughput trade-offs in ASIC design
- Frontend–backend separation in real ASIC flows

Beyond coding, it emphasized **engineering judgment**, especially knowing where to stop locally and where different infrastructure is required.

---

## Practical Usage and Applications

An iterative SHA-256 core like this is suitable for:
- Secure boot and firmware authentication
- Embedded security processors
- Resource-constrained SoCs
- Cryptographic accelerators where area and power matter more than throughput

The architecture can be extended to:
- Pipelined variants (for higher throughput)
- Multi-hash engines
- Integration into larger SoC designs

---

## Project Status

- ✔ RTL design complete  
- ✔ Functional verification complete  
- ✔ Gate-level netlist generated  
- ✔ Backend-ready (physical design can be run on dedicated Linux / server environments)

Future work will explore **pipelined SHA-256 architectures** and compare them against this iterative baseline.

---

## Repository Structure :
sha256-asic/
├── rtl/ # Verilog RTL source files
├── tb/ # Testbench
├── synth/ # Synthesis scripts and reports
├── netlist/ # Gate-level netlist
└── docs/ # Architecture and flow documentation

