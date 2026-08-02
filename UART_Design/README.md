# UART Protocol Design in Verilog

## Overview
This project implements a UART (Universal Asynchronous Receiver
Transmitter) with separate Transmitter (TX) and Receiver (RX) modules,
connected in loopback for verification - 8 data bits, 1 start bit,
1 stop bit, no parity.

## Features
- FSM-based TX and RX modules (IDLE > START > DATA > STOP)
- Internal baud rate generator (16x oversampling), configurable via parameters
- Loopback top module (uart_top) connects TX output directly to RX input
- Fully simulated in Vivado (XSim) - no physical board or PC serial port required

## Files
- uart_tx_rx.v - Contains baud_gen, uart_tx, uart_rx, and top-level uart_top
- tb_uart_top.v - Testbench, sends byte 0xA5 and checks it is received correctly
- waveform.png - Simulation waveform screenshot

## How to Run (Vivado)
1. Create a new RTL project in Vivado (no board needed).
2. Add uart_tx_rx.v as a Design Source.
3. Add tb_uart_top.v as a Simulation Source.
4. Flow Navigator > Simulation > Run Behavioral Simulation.
5. Check the Tcl console/log for PASS: Received data = a5.

## Result
The testbench transmits byte 0xA5 through the TX module, which is
received bit-by-bit by the RX module and reassembled. The simulation
confirms rx_data == 0xA5, verifying correct UART operation.

## Tools Used
- Verilog HDL
- Xilinx Vivado (Behavioral Simulation / XSim)