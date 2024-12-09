import pcpu::*;

module CSSTE_Pipe (
   input         clk_100mhz,
   input         RSTN,
   input  [ 3:0] BTN_y,
   input  [15:0] SW,
   output [ 3:0] Blue,
   output [ 3:0] Green,
   output [ 3:0] Red,
   output        HSYNC,
   output        VSYNC,
   output [15:0] LED_out,
   output [ 7:0] AN,
   output [ 7:0] segment
);
   wire        rst;
   wire        MemRW_Mem;
   wire        Clk_CPU;
   wire [ 1:0] counter_set;
   wire [ 3:0] BTN_OK;
   wire [ 7:0] point_out;
   wire [ 7:0] LE_out;
   wire [ 9:0] ram_addr;
   wire [15:0] SW_OK;
   wire [31:0] clkdiv;
   wire [31:0] Addr_out;
   wire [31:0] Data_out;
   wire [31:0] PC_out_IF;
   wire [31:0] inst_IF;
   wire [31:0] Cpu_data4bus;
   wire [31:0] douta;
   wire [31:0] ram_data_in;
   wire [31:0] Peripheral_in;
   wire [31:0] counter_out;
   wire [31:0] Disp_num;
   wire        data_ram_we;
   wire        GPIOf_we;
   wire        GPIOe_we;
   wire        counter_we;
   wire        counter0_OUT;
   wire        counter1_OUT;
   wire        counter2_OUT;

   always @(0);  // this line is to make the formatter happy
   RV32_Regs_t   regs;
   VGA_Signals_t vga_signals;

   Pipeline_CPU U1 (
      .clk(Clk_CPU),
      .rst(rst),

      .Data_in  (Cpu_data4bus),
      .inst_IF  (inst_IF),
      .PC_out_IF(PC_out_IF),
      .MemRW_Mem(MemRW_Mem),
      .Addr_out (Addr_out),
      .Data_out (Data_out),

      // external vga singals
      .vga_signals(vga_signals),
      .regs       (regs)
   );

   ROM_D U2 (  // instruction memory
      .a  (PC_out_IF[11:2]),  // address
      .spo(inst_IF)           // instruction output
   );

   RAM_B U3 (  // data memory
      .addra(ram_addr),
      .clka (~clk_100mhz),
      .dina (ram_data_in),
      .douta(douta),
      .wea  (data_ram_we & SW[15])
   );

   MIO_BUS U4 (
      .clk            (clk_100mhz),
      .rst            (rst),
      .BTN            (BTN_OK),
      .SW             (SW_OK),
      .mem_w          (MemRW_Mem),
      .Cpu_data2bus   (Data_out),
      .addr_bus       (Addr_out),
      .ram_data_out   (douta),
      .led_out        (LED_out),
      .counter_out    (counter_out),
      .counter0_out   (counter0_OUT),
      .counter1_out   (counter1_OUT),
      .counter2_out   (counter2_OUT),
      .Cpu_data4bus   (Cpu_data4bus),
      .ram_data_in    (ram_data_in),
      .ram_addr       (ram_addr),
      .data_ram_we    (data_ram_we),
      .GPIOf0000000_we(GPIOf_we),
      .GPIOe0000000_we(GPIOe_we),
      .counter_we     (counter_we),
      .Peripheral_in  (Peripheral_in)
   );

   Multi_8CH32 U5 (
      .clk      (~Clk_CPU),
      .rst      (rst),
      .EN       (GPIOe_we),
      .Test     (SW_OK[7:5]),
      .point_in ({clkdiv[31:0], clkdiv[31:0]}),
      .LES      (64'b0),
      .Data0    (Peripheral_in),
      .data1    ({PC_out_IF[31:2], 2'b0}),
      .data2    (inst_IF),
      .data3    (counter_out),
      .data4    (Addr_out),
      .data5    (Data_out),
      .data6    (Cpu_data4bus),
      .data7    (PC_out_IF),
      .point_out(point_out),
      .LE_out   (LE_out),
      .Disp_num (Disp_num)
   );

   Seg7_Dev U6 (
      .les     (LE_out),
      .point   (point_out),
      .disp_num(Disp_num),
      .scan    (clkdiv[18:16]),
      .AN      (AN),
      .segment (segment)
   );

   SPIO U7 (
      .clk        (~Clk_CPU),
      .rst        (rst),
      .Start      (clkdiv[20]),
      .EN         (GPIOf_we),
      .P_Data     (Peripheral_in),
      .counter_set(counter_set),
      .LED_out    (LED_out)
   );

   clk_div U8 (
      .clk    (clk_100mhz),
      .rst    (rst),
      .SW2    (SW_OK[2]),
      .SW8    (SW_OK[8]),
      .STEP   (SW[10] | BTN_OK[0]),
      .clkdiv (clkdiv),
      .Clk_CPU(Clk_CPU)
   );

   SAnti_jitter U9 (
      .clk   (clk_100mhz),
      .RSTN  (RSTN),
      .readn (1'b0),
      .Key_y (BTN_y),
      .SW    (SW),
      .BTN_OK(BTN_OK),
      .SW_OK (SW_OK),
      .rst   (rst)
   );

   Counter_x U10 (
      .clk         (~Clk_CPU),
      .rst         (rst),
      .clk0        (clkdiv[6]),
      .clk1        (clkdiv[9]),
      .clk2        (clkdiv[11]),
      .counter_we  (counter_we),
      .counter_val (Peripheral_in),
      .counter_ch  (counter_set),
      .counter0_OUT(counter0_OUT),
      .counter1_OUT(counter1_OUT),
      .counter2_OUT(counter2_OUT),
      .counter_out (counter_out)
   );

   VGA U11 (
      .clk_25m (clkdiv[1]),
      .clk_100m(clk_100mhz),
      .rst     (rst),

      // required signals
      .PC_IF    (PC_out_IF),
      .inst_IF  (inst_IF),
      .MemRW_Mem(MemRW_Mem),
      .Data_out (Data_out),
      .Addr_out (Addr_out),

      // external packed signals (just for better debugging experience)
      .regs       (regs),
      .vga_signals(vga_signals),

      .hs   (HSYNC),
      .vs   (VSYNC),
      .vga_r(Red),
      .vga_g(Green),
      .vga_b(Blue)
   );

endmodule
