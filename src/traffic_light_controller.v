module traffic_light_controller (
    input clk,
    input reset,
    input emergency,
    input [1:0] emg_dir,
    output reg [2:0] NS,
    output reg [2:0] EW
);

parameter NS_G = 3'd0,
          NS_Y = 3'd1,
          EW_G = 3'd2,
          EW_Y = 3'd3,
          EMG  = 3'd4;

reg [2:0] state, next_state;
reg [23:0] timer;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= NS_G;
        timer <= 0;
    end else begin
        state <= next_state;
        timer <= timer + 1;
    end
end

always @(*) begin
    next_state = state;

    if (emergency)
        next_state = EMG;
    else begin
        case (state)
            NS_G: if (timer == 24'd5000000) next_state = NS_Y;
            NS_Y: if (timer == 24'd2000000) next_state = EW_G;
            EW_G: if (timer == 24'd5000000) next_state = EW_Y;
            EW_Y: if (timer == 24'd2000000) next_state = NS_G;
        endcase
    end
end

always @(*) begin
    NS = 3'b100;
    EW = 3'b100;

    case (state)
        NS_G: begin NS = 3'b001; EW = 3'b100; end
        NS_Y: begin NS = 3'b010; EW = 3'b100; end
        EW_G: begin NS = 3'b100; EW = 3'b001; end
        EW_Y: begin NS = 3'b100; EW = 3'b010; end
        EMG: begin
            if (emg_dir == 2'b00 || emg_dir == 2'b10)
                NS = 3'b001;
            else
                EW = 3'b001;
        end
    endcase
end

endmodule
