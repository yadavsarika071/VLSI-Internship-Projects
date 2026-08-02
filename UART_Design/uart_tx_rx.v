module baud_gen #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
) (
    input  wire clk,
    input  wire reset,
    output reg  tick
);
    localparam integer DIVISOR = CLK_FREQ / (BAUD_RATE * 16);
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            tick  <= 0;
        end else if (count == DIVISOR - 1) begin
            count <= 0;
            tick  <= 1;
        end else begin
            count <= count + 1;
            tick  <= 0;
        end
    end
endmodule

module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire        tick,
    input  wire        tx_start,
    input  wire [7:0]  tx_data,
    output reg         tx,
    output reg         tx_busy
);
    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0] state;
    reg [3:0] tick_cnt;
    reg [2:0] bit_idx;
    reg [7:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; tx <= 1'b1; tx_busy <= 0;
            tick_cnt <= 0; bit_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1;
                        state    <= START;
                        tick_cnt <= 0;
                    end
                end
                START: begin
                    tx <= 1'b0;
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0; bit_idx <= 0; state <= DATA;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                DATA: begin
                    tx <= data_reg[bit_idx];
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0;
                            if (bit_idx == 7) state <= STOP;
                            else bit_idx <= bit_idx + 1;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                STOP: begin
                    tx <= 1'b1;
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0; tx_busy <= 0; state <= IDLE;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule

module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire        tick,
    input  wire        rx,
    output reg  [7:0]  rx_data,
    output reg          rx_done
);
    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0] state;
    reg [3:0] tick_cnt;
    reg [2:0] bit_idx;
    reg [7:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; rx_done <= 0; tick_cnt <= 0; bit_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    if (rx == 1'b0) begin
                        state <= START; tick_cnt <= 0;
                    end
                end
                START: begin
                    if (tick) begin
                        if (tick_cnt == 7) begin
                            tick_cnt <= 0; state <= DATA; bit_idx <= 0;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                DATA: begin
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0;
                            data_reg[bit_idx] <= rx;
                            if (bit_idx == 7) state <= STOP;
                            else bit_idx <= bit_idx + 1;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                STOP: begin
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0;
                            rx_data <= data_reg;
                            rx_done <= 1;
                            state <= IDLE;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule

module uart_top (
    input  wire       clk,
    input  wire       reset,
    input  wire        tx_start,
    input  wire [7:0]  tx_data,
    output wire        tx_busy,
    output wire [7:0]  rx_data,
    output wire        rx_done
);
    wire tick;
    wire serial_line;

    baud_gen #(.CLK_FREQ(50_000_000), .BAUD_RATE(9600)) BAUD (
        .clk(clk), .reset(reset), .tick(tick)
    );

    uart_tx TX (
        .clk(clk), .reset(reset), .tick(tick),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx(serial_line), .tx_busy(tx_busy)
    );

    uart_rx RX (
        .clk(clk), .reset(reset), .tick(tick),
        .rx(serial_line), .rx_data(rx_data), .rx_done(rx_done)
    );

endmodule