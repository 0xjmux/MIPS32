# MIPS32
Pipelined MIPS32 Processor Built in Verilog 

This is a pipelined 32 bit MIPS processor built in verilog that was completed in my Organization of Digital Computers Laboratory class. This design fufills the majority of the MIPS32 design spec, with the ALU_OP codes being slightly different from the actual ISA in order to comply with how the professor had designed the grading testbench.

In order to see the processor in action, Import all files into Vivado and run the behavioral simulation. 

Some screenshots:

### Waveform showing data forwarding
![img_1](/images/Data_forwarding.png) 

### Waveform showing Data Hazard Avoidance
![img_2](/images/Data_Hazard_forwarded.png) 

### Successful Testbench Output
![img_3](/images/tb_success.png) 

### FPGA Utilization Graph
![img_4](/images/fpga_util.png) 

### Power Utilization
![img_5](/images/power_util.png) 

### Processor Schematic
![img_6](/images/schematic.png) 
