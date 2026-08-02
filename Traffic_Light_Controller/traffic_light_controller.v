// =========================================================
// FPGA-Based Traffic Light Controller with Priority System
// 2-way intersection (North-South & East-West)
// Emergency override input for priority vehicles
// =========================================================
module traffic_light_controller (
    input  wire       clk,
    input  wire        reset,
    input  wire        emergency,       // 1 = emergency vehicle detected
    output reg  [1:0]  ns_light,        // 00=Red, 01=Yellow, 10=Green
    output reg  [1:0]  ew_light
);

    // Light encodings
    localparam RED    = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN  = 2'b10;

    // States
    localparam NS_GREEN   = 3'd0;
    localparam NS_YELLOW  = 3'd1;
    localparam EW_GREEN   = 3'd2;
    localparam EW_YELLOW  = 3'd3;
    localparam ALL_RED_EMG= 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] timer;

    localparam GREEN_TIME  = 4'd8;
    localparam YELLOW_TIME = 4'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= NS_GREEN;
            timer <= 0;
        end else if (emergency) begin
            state <= ALL_RED_EMG;
            timer <= 0;
        end else if (timer == 0) begin
            state <= next_state;
            case (next_state)
                NS_GREEN, EW_GREEN  : timer <= GREEN_TIME;
                NS_YELLOW, EW_YELLOW: timer <= YELLOW_TIME;
                default: timer <= 0;
            endcase
        end else begin
            timer <= timer - 1;
        end
    end

    always @(*) begin
        case (state)
            NS_GREEN : next_state = NS_YELLOW;
            NS_YELLOW: next_state = EW_GREEN;
            EW_GREEN : next_state = EW_YELLOW;
            EW_YELLOW: next_state = NS_GREEN;
            ALL_RED_EMG: next_state = emergency ? ALL_RED_EMG : NS_GREEN;
            default  : next_state = NS_GREEN;
        endcase
    end

    always @(*) begin
        case (state)
            NS_GREEN : begin ns_light = GREEN;  ew_light = RED;    end
            NS_YELLOW: begin ns_light = YELLOW; ew_light = RED;    end
            EW_GREEN : begin ns_light = RED;    ew_light = GREEN;  end
            EW_YELLOW: begin ns_light = RED;    ew_light = YELLOW; end
            ALL_RED_EMG: begin ns_light = RED;  ew_light = RED;    end
            default  : begin ns_light = RED;    ew_light = RED;    end
        endcase
    end

endmodule