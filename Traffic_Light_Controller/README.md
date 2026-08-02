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
- Fully simulated in Vivado (XSim) - no physical board required

## Files
- traffic_light_controller.v - Main design (FSM)
- tb_traffic_light.v - Testbench
- waveform.png - Simulation waveform screenshot

## How to Run (Vivado)
1. Create a new RTL project in Vivado (no board needed).
2. Add traffic_light_controller.v as a Design Source.
3. Add tb_traffic_light.v as a Simulation Source.
4. Flow Navigator > Simulation > Run Behavioral Simulation.
5. Observe ns_light, ew_light, and emergency in the waveform viewer.

## Result
The simulation shows normal NS/EW green-yellow cycling, and confirms
that asserting emergency immediately forces both lights to Red until
it is de-asserted, after which the normal cycle resumes.

## Tools Used
- Verilog HDL
- Xilinx Vivado (Behavioral Simulation / XSim)