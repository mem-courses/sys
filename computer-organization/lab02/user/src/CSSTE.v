`timescale 1ns / 1ps
module CSSTE (
   input clk_100mhz,
   input RSTN,
   input [3:0] BTN_y,
   input [15:0] SW,
   output [3:0] Blue,
   output [3:0] Green,
   output [3:0] Red,
   output HSYNC,
   output VSYNC,
   output [15:0] LED_out,
   output [7:0] AN,
   output [7:0] segment
);
   wire [3:0] BTN_OK;
   wire [9:0] ram_addr;
   wire data_ram_we, GPIOf_we, GPIOe_we, counter_we;
   wire [15:0] SW_OK;
   wire rst, MemRW, Clk_CPU;
   wire [1:0] counter_set;
   wire [7:0] point_out, LE_out;
   wire counter0_OUT, counter1_OUT, counter2_OUT;
   wire [31:0] clkdiv, Addr_out, Data_out, PC_out, spo;
   wire [31:0] Cpu_data4bus, douta, ram_data_in, Peripheral_in;
   wire [31:0] counter_out, Disp_num;

   SCPU U1 (
      .Addr_out(Addr_out),
      .Data_in(Cpu_data4bus),
      .Data_out(Data_out),
      .MIO_ready(1'b0),
      .MemRW(MemRW),
      .PC_out(PC_out),
      .clk(Clk_CPU),
      .inst_in(spo),
      .rst(rst)
   );

   ROM_D U2 (
      .a  (PC_out[11:2]),
      .spo(spo)
   );

   RAM_B U3 (
      .addra(ram_addr),
      .clka (~clk_100mhz),
      .dina (ram_data_in),
      .douta(douta),
      .wea  (data_ram_we)
   );

   MIO_BUS U4 (
      .clk(clk_100mhz),
      .rst(rst),
      .BTN(BTN_OK),
      .SW(SW_OK),
      .mem_w(MemRW),
      .Cpu_data2bus(Data_out),
      .addr_bus(Addr_out),
      .ram_data_out(douta),
      .led_out(LED_out),
      .counter_out(counter_out),
      .counter0_out(counter0_OUT),
      .counter1_out(counter1_OUT),
      .counter2_out(counter2_OUT),
      .Cpu_data4bus(Cpu_data4bus),
      .ram_data_in(ram_data_in),
      .ram_addr(ram_addr),
      .data_ram_we(data_ram_we),
      .GPIOf0000000_we(GPIOf_we),
      .GPIOe0000000_we(GPIOe_we),
      .counter_we(counter_we),
      .Peripheral_in(Peripheral_in)
   );

   Multi_8CH32 U5 (
      .clk(~Clk_CPU),
      .rst(rst),
      .EN(GPIOe_we),
      .Test(SW_OK[7:5]),
      .point_in({clkdiv[31:0], clkdiv[31:0]}),
      .LES(64'b0),
      .Data0(Peripheral_in),
      .data1({PC_out[31:2], 2'b0}),
      .data2(spo),
      .data3(counter_out),
      .data4(Addr_out),
      .data5(Data_out),
      .data6(Cpu_data4bus),
      .data7(PC_out),
      .point_out(point_out),
      .LE_out(LE_out),
      .Disp_num(Disp_num)
   );

   Seg7_Dev U6 (
      .les(LE_out),
      .point(point_out),
      .disp_num(Disp_num),
      .scan(clkdiv[18:16]),
      .AN(AN),
      .segment(segment)
   );

   SPIO U7 (
      .clk(~Clk_CPU),
      .rst(rst),
      .Start(clkdiv[20]),
      .EN(GPIOf_we),
      .P_Data(Peripheral_in),
      .counter_set(counter_set),
      .LED_out(LED_out)
   );

   clk_div U8 (
      .clk(clk_100mhz),
      .rst(rst),
      .SW2(SW_OK[2]),
      .SW8(SW_OK[8]),
      .STEP(SW[10] | BTN_OK[0]),
      .clkdiv(clkdiv),
      .Clk_CPU(Clk_CPU)
   );

   SAnti_jitter U9 (
      .clk(clk_100mhz),
      .RSTN(RSTN),
      .readn(1'b0),
      .Key_y(BTN_y),
      .SW(SW),
      .BTN_OK(BTN_OK),
      .SW_OK(SW_OK),
      .rst(rst)
   );

   Counter_x U10 (
      .clk(~Clk_CPU),
      .rst(rst),
      .clk0(clkdiv[6]),
      .clk1(clkdiv[9]),
      .clk2(clkdiv[11]),
      .counter_we(counter_we),
      .counter_val(Peripheral_in),
      .counter_ch(counter_set),
      .counter0_OUT(counter0_OUT),
      .counter1_OUT(counter1_OUT),
      .counter2_OUT(counter2_OUT),
      .counter_out(counter_out)
   );

   VGA U11 (
      .clk_25m(clkdiv[1]),
      .clk_100m(clk_100mhz),
      .rst(rst),
      .pc(PC_out),
      .inst(spo),
      .alu_res(Addr_out),
      .mem_wen(MemRW),
      .dmem_o_data(douta),
      .dmem_i_data(ram_data_in),
      .dmem_addr(Addr_out),
      .hs(HSYNC),
      .vs(VSYNC),
      .vga_r(Red),
      .vga_g(Green),
      .vga_b(Blue)
   );

endmodule
