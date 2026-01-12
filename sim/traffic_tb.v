module traffic_tb;

reg clk;
reg reset;
reg emergency;
reg [1:0] emg_dir;

wire [2:0] NS;
wire [2:0] EW;

traffic_light_controller dut (
    .clk(clk),
    .reset(reset),
    .emergency(emergency),
    .emg_dir(emg_dir),
    .NS(NS),
    .EW(EW)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    emergency = 0;
    emg_dir = 2'b00;

    #20 reset = 0;

    #200 emergency = 1;
    emg_dir = 2'b01;

    #100 emergency = 0;

    #300 $finish;
end

endmodule
