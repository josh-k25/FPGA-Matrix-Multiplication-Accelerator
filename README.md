# FPGA Matrix Multiplication Accelerator

A SystemVerilog implementation of hardware accelerators for matrix multiplication.

The project currently implements a 4×4 matrix multiplier using a single multiply-accumulate (MAC) datapath. Matrix elements are processed sequentially using row, column, and inner-dimension counters, with an FSM controlling accumulation and writes to the output memory.

The next stage of the project is an output-stationary systolic array implementation, allowing multiple matrix output elements to be computed concurrently while reusing data through neighboring processing elements.

## Current Architecture: Single-MAC Matrix Multiplier

The current implementation computes:

\[
C = A \times B
\]

for two 4×4 matrices.

Each output element is calculated as:

\[
C_{ij} = \sum_{k=0}^{3} A_{ik}B_{kj}
\]

A single MAC datapath is reused across all 16 output elements. Three counters track the current row `i`, column `j`, and inner-product index `k`.

### Datapath

- 4×4 input matrix A stored in ROM
- 4×4 input matrix B stored in ROM
- 8-bit unsigned matrix elements
- 16-bit multiplication result
- 18-bit accumulator
- 4×4 output matrix C stored in RAM
- Row, column, and `k` counters for matrix traversal

Memory addresses are generated as:

\[
A[i][k] = 4i + k
\]

\[
B[k][j] = 4k + j
\]

\[
C[i][j] = 4i + j
\]

### Controller

The accelerator is controlled by an FSM with five states:

- `IDLE` — waits for `start`
- `PREP` — clears the accumulator before computing an output element
- `CALCULATE` — performs the four MAC operations for the current output
- `WRITE` — writes the completed result to matrix C
- `DONE` — signals completion and resets the matrix counters

## Verification

The current SystemVerilog testbench runs a complete 4×4 matrix multiplication and displays all 16 elements of the resulting matrix C after the accelerator asserts `done`.

## Planned Systolic Array Architecture

The next implementation will replace the single shared MAC with a 2D output-stationary systolic array.

Each processing element (PE) will:

- Perform a local multiply-accumulate operation
- Hold one output partial sum locally
- Forward matrix A values horizontally
- Forward matrix B values vertically
- Propagate valid signals with the operands

This architecture will allow multiple MAC operations to execute concurrently while increasing data reuse and reducing repeated memory accesses.

The single-MAC implementation will be retained as a baseline for comparing latency, throughput, and FPGA resource usage against the systolic implementation.

## Tools

- SystemVerilog
- Icarus Verilog
- GTKWave
- Vivado
