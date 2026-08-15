# FPGA-Based Traffic Light Controller with Priority System

## Overview
This project implements a 2-way (North-South / East-West) traffic light
controller using Verilog. It includes an emergency vehicle priority
override: when the emergency signal is asserted, both directions turn
Red until the emergency clears, after which normal cycling resumes.

## Features
- FSM-based design (5 states: NS_GREEN, NS_YELLOW, EW_GREEN, EW_YELLOW, ALL_RED_EMERGENCY)
- Configurable green/yellow timing via parameters
- Emergency override input for priority vehicles
- Fully simulated in Xilinx ISE Design Suite 14.7 (ISim) - no physical board required

## Files
- traffic_light_controller.v - Main design (FSM)
- tb_traffic_light.v - Testbench
- traffic .jpg - Simulation waveform screenshot

## How to Run (Xilinx ISE 14.7)
1. Create a new project in ISE Project Navigator (no board needed).
2. Add traffic_light_controller.v as a Design Source (Verilog Module).
3. Add tb_traffic_light.v as a Simulation Source (Verilog Module).
4. Switch to Simulation view, select the testbench.
5. Double-click "Simulate Behavioral Model" under Processes.
6. Observe ns_light, ew_light, and emergency in the ISim waveform viewer.

## Result
The simulation shows normal NS/EW green-yellow cycling, and confirms
that asserting emergency immediately forces both lights to Red until
it is de-asserted, after which the normal cycle resumes.

## Tools Used
- Verilog HDL
- Xilinx ISE Design Suite 14.7 (ISim Simulator)