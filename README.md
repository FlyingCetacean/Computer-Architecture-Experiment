# Computer-Architecture-Experiment
【2019-2020 Spring】Computer Architecture experiment

[toc]

## Lab01

### 一、  实验名称

**`FPGA` 基础实验：LED Flow Water Light**

### **二、  实验目的**

1. 熟悉`Xilinx`逻辑设计工具`Vivado`的基本操作；

2. 掌握使用`VerilogHDL`进行简单的逻辑设计;

3. 使用功能仿真;

### 三、  功能实现

1. 源文件`flowing_light.v`

   clock 和reset作为输入信号，控制led灯的亮与灭；当reset信号为1时，计数器cut_reg被初始化为0，输出信号 led[0]被初始化为00000001；当reset信号为0时，计数器在每个时钟信号上升沿加1计数，直至加至24位值全为1时，输出信号左移一位；

   ![image-20210528135223284](C:\Users\73137\AppData\Roaming\Typora\typora-user-images\image-20210528135223284.png)

2. 仿真激励文件`flowing_light_tb.v` 

### 四、  结果展示

 下图为基于以上模块代码和激励测试文件运行仿真后所得到的波形。

由波形可得，在时钟上升沿时且reset置1时，led[0]=1表示第一个灯亮。

### 五、心得体会

Lab01的难度并不算大，仔细按照实验指导书上给出的内容就可以得到最终的结果。但是在实操过程中也遇到了很多问题，如代码格式，端口命名。通过解决这些问题，我初步掌握了Xilinx逻辑设计工具Vivado的基本操作，对Verilog代码逻辑与代码格式有了初步认识，学会了使用VerilogHDL硬件描述语言进行简单的逻辑设计。

## Lab02

## Lab03



## Lab04



## Lab05



## Lab06

