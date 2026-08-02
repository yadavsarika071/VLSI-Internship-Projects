`timescale 1ns/1ps
module tb_uart_top;

    reg clk, reset, tx_start;
    reg [7:0] tx_data;
    wire tx_busy, rx_done;
    wire [7:0] rx_data;

    uart_top dut (
        .clk(clk), .reset(reset),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx_busy(tx_busy), .rx_data(rx_data), .rx_done(rx_done)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; reset = 1; tx_start = 0; tx_data = 8'h00;
        #40 reset = 0;

        #40;
        tx_data  = 8'hA5;
        tx_start = 1;
        #20 tx_start = 0;

        wait (rx_done == 1);
        #40;
        if (rx_data == 8'hA5)
            $display("PASS: Received data = %h", rx_data);
        else
            $display("FAIL: Received data = %h", rx_data);

        #200 $finish;
    end

    initial begin
        $dumpfile("uart_top.vcd");
        $dumpvars(0, tb_uart_top);
    end

endmodule