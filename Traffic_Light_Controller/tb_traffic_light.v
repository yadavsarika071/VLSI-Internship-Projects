`timescale 1ns/1ps
module tb_traffic_light;

    reg clk, reset, emergency;
    wire [1:0] ns_light, ew_light;

    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .emergency(emergency),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; emergency = 0;
        #12 reset = 0;

        #200;

        emergency = 1;
        #40;
        emergency = 0;

        #200;

        $display("Simulation finished");
        $finish;
    end

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);
    end

    initial begin
        $monitor("t=%0t state_ns=%b state_ew=%b emergency=%b",
                  $time, ns_light, ew_light, emergency);
    end

endmodule