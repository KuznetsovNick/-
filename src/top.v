module top(
    input CLK,
    input btn1,
    input btn2,

    output TXD,
    output ledG,
    output ledR
);

reg [21:0]cnt = 25'b0;
reg [5:0]rom_addr = 6'b0;
reg uart_start = 1'b0;

reg [6:0] resync;
reg inc_cntr;
reg mode2 = 1'b1;

reg led;
initial led <= 1'b1;

always @(posedge CLK) begin
    //if (cnt == 25'b0) begin
    if ( (~btn1 && cnt == 25'b0) || (mode2 && cnt == 25'b0) ) begin
        rom_addr <= rom_addr + 6'b1;
        uart_start <= 1'b1;
    end
    else begin
        uart_start <= 1'b0;
    end

    if(~btn1 || mode2)
        led <= 1'b0;
    else
        led <= 1'b1;

    cnt <= cnt + 25'b1;
end

wire [7:0]uart_data;

rom rom(rom_addr, CLK, uart_data);

uart_tx uart_tx(CLK, uart_start, uart_data, led, TXD);

assign ledG = led;
assign ledR = ~led;


always @ (posedge CLK)
begin 
   resync <= {resync[2:0],btn2};
   inc_cntr <= ~resync[3] & resync[2];
   if(inc_cntr)
        mode2 = ~mode2;
end


endmodule
