`timescale 1ns / 1ps

module VGA_tb;
   // VGA 模块的输出信号
   wire       HSYNC;  // 行同步信号
   wire       VSYNC;  // 场同步信号
   wire       video_on;  // 显示有效信号
   wire [9:0] vga_x;  // x坐标 (0-639)
   wire [8:0] vga_y;  // y坐标 (0-479)
   wire [3:0] Red, Green, Blue;  // RGB颜色分量,每个4位

   // 时钟和复位信号
   reg clk_25mhz;  // VGA显示时钟(25MHz)
   reg clk_100mhz;  // 系统主时钟(100MHz)
   reg rst;  // 复位信号

   // 实例化VGA模块
   VGA ut (
      .clk_25m    (clk_25mhz),     // 25MHz显示时钟
      .clk_100m   (clk_100mhz),    // 100MHz系统时钟
      .rst        (rst),           // 复位信号
      .pc         (32'hDEADBEEF),  // 程序计数器值(测试用)
      .inst       (32'hDEADBEEF),  // 指令值(测试用)
      .alu_res    (32'hDEADBEEF),  // ALU结果(测试用)
      .mem_wen    (0),             // 内存写使能
      .dmem_o_data(32'hDEADBEEF),  // 数据存储器输出(测试用)
      .dmem_i_data(32'hDEADBEEF),  // 数据存储器输入(测试用)
      .dmem_addr  (32'hDEADBEEF),  // 数据存储器地址(测试用)
      .hs         (HSYNC),         // 行同步输出
      .vs         (VSYNC),         // 场同步输出
      .vga_r      (Red),           // 红色分量输出
      .vga_g      (Green),         // 绿色分量输出
      .vga_b      (Blue),          // 蓝色分量输出
      .video_on   (video_on),      // 显示有效信号输出
      .vga_x      (vga_x),         // 当前像素x坐标
      .vga_y      (vga_y)          // 当前像素y坐标
   );

   // 生成25MHz和100MHz的时钟信号
   initial begin
      clk_25mhz  = 0;
      clk_100mhz = 0;
   end

   always #20 clk_25mhz = ~clk_25mhz;  // 生成25MHz时钟(周期40ns)
   always #5 clk_100mhz = ~clk_100mhz;  // 生成100MHz时钟(周期10ns)

   // 复位逻辑
   initial begin
      rst = 1;  // 初始化时置位复位信号
      #100;  // 保持复位100ns
      rst = 0;  // 释放复位信号
   end

   // 打开日志文件
   integer file;  // 用于记录像素数据的文件句柄
   initial begin
      file = $fopen("pixel_data.txt", "w");  // 以写模式打开文件
      if (file == 0) begin  // 检查文件是否成功打开
         $display("错误: 无法打开文件.");
         $finish;
      end
   end

   // 在每个像素时钟上升沿记录像素数据
   always @(posedge clk_25mhz) begin
      // 当显示有效且在有效显示区域内时记录像素数据
      if (video_on && vga_x < 640 && vga_y < 480) begin
         $fwrite(file, "x=%d, y=%d, R=%d, G=%d, B=%d\n", vga_x, vga_y, Red, Green, Blue);
      end
      // 当扫描到最后一个像素时,关闭文件并结束仿真
      if (vga_y == 479 && vga_x == 639) begin
         $fclose(file);
         $finish;
      end
   end
endmodule
