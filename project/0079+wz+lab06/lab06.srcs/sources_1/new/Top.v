`timescale 1ns / 1ps


module Top(
    input clk,
    input reset
    );
    reg [31:0] PC;
    wire [8:0] CTRL_OUT;
    wire [31:0] READ_DATA_1;
    wire [31:0] READ_DATA_2;
    wire [31:0] REG_WRITE_DATA;
    wire [3:0] ALU_CTRL_OUT;
    wire [31:0] ALU_RES;
    wire [4:0] DST_REG;
    wire ZERO;
    wire BRANCH;
     
    // IF and ID
    reg [31:0] IFID_pcPlus4, IFID_inst;
    wire [4:0] IFID_INST_RS = IFID_inst[25:21];
    wire [4:0] IFID_INST_RT = IFID_inst[20:16];
    wire [4:0] IFID_INST_RD = IFID_inst[15:11];
   
    
    // ID and EX
    reg [31:0] IDEX_readData1;
    reg [31:0] IDEX_readData2;
    reg [31:0] IDEX_IMMSext;
    reg [4:0] IDEX_inst_Rs;
    reg [4:0] IDEX_inst_Rt;
    reg [4:0] IDEX_inst_Rd;
    reg [8:0] IDEX_Ctr;
    
    wire IDEX_REGDST = IDEX_Ctr[8];
    wire [1:0] IDEX_ALUOP = IDEX_Ctr[7:6];
    wire IDEX_ALUSRC= IDEX_Ctr[5]; 
    wire IDEX_BRANCH = IDEX_Ctr[4];
    wire IDEX_MEMREAD = IDEX_Ctr[3];
    wire IDEX_MEMWRITE = IDEX_Ctr[2];
    wire IDEX_REGWRITE = IDEX_Ctr[1];
    wire IDEX_MEMTOREG = IDEX_Ctr[0];
        
    // EX and EM
    reg [31:0] EXMEM_aluRes, EXMEM_writeData;
    reg [4:0] EXMEM_dstReg;
    reg [4:0] EXMEM_Ctr;
    reg EXMEM_zero;
    wire EXMEM_BRANCH = EXMEM_Ctr[4];
    wire EXMEM_MEMREAD = EXMEM_Ctr[3];
    wire EXMEM_MEMWRITE = EXMEM_Ctr[2];
    wire EXMEM_REGWRITE = EXMEM_Ctr[1];
    wire EXMEM_MEMTOREG = EXMEM_Ctr[0];
        
    // MEM and WB
    reg [31:0] MEMWB_readData, MEMWB_aluRes;
    reg [4:0] MEMWB_dstReg;
    reg [1:0] MEMWB_Ctr;
    wire MEMWB_REGWRITE = MEMWB_Ctr[1];
    wire MEMWB_MEMTOREG = MEMWB_Ctr[0];
    
    // Hazard detection
    wire STALL = IDEX_MEMREAD & 
        (IDEX_inst_Rt == IFID_INST_RS | IDEX_inst_Rt == IFID_INST_RT);
    
    
    // IF
    wire [31:0] IF_INST;
    wire [31:0] PC_PLUS_4;
    wire [31:0]  BRANCH_ADDR;
    wire [31:0] next;
    
    assign PC_PLUS_4 = PC + 4;
    
    mux32 nextMux(
        .input2(PC_PLUS_4), 
        .input1(BRANCH_ADDR), 
        .out(next),
        .sel(BRANCH)
    );
        
    inst_memory instMem(
        .readAddress(PC), 
        .inst(IF_INST)
    );
    
    always @ (posedge clk)
    begin
        if (!STALL)
        begin
            IFID_pcPlus4 <= PC_PLUS_4;
            IFID_inst <= IF_INST;
            PC <= next;
        end
        if (BRANCH)
            IFID_inst <= 0; 
    end
    
    // ID
    
    Ctr mainCtr(
        .OpCode(IFID_inst[31:26]), 
        .regDst(CTRL_OUT[8]), 
        .aluOp(CTRL_OUT[7:6]), 
        .aluSrc(CTRL_OUT[5]), 
        .branch(CTRL_OUT[4]),
        .memRead(CTRL_OUT[3]), 
        .memWrite(CTRL_OUT[2]), 
        .regWrite(CTRL_OUT[1]),
        .memToReg(CTRL_OUT[0])
    );
   
   Registers registers(
        .Clk(clk), 
        .readReg1(IFID_INST_RS), 
        .readReg2(IFID_INST_RT), 
        .writeReg(MEMWB_dstReg), 
        .writeData(REG_WRITE_DATA), 
        .regWrite(MEMWB_REGWRITE), 
        .reset(reset), 
        .readData1(READ_DATA_1), 
        .readData2(READ_DATA_2));
    
    wire [31:0] IMM_SEXT;
    
    signext sext(
        .inst(IFID_inst[15:0]), 
        .data(IMM_SEXT)
    );
    
    wire [31:0] IMM_SEXT_SHIFT = IMM_SEXT << 2;
    
    assign BRANCH_ADDR = IMM_SEXT_SHIFT + IFID_pcPlus4;
    assign BRANCH = (READ_DATA_1 == READ_DATA_2) & CTRL_OUT[4];
    
    always @ (posedge clk)
    begin
        IDEX_Ctr <= STALL ? 0 : CTRL_OUT;
        IDEX_readData1 <= READ_DATA_1;
        IDEX_readData2 <= READ_DATA_2;
        IDEX_IMMSext <= IMM_SEXT;
        IDEX_inst_Rs <= IFID_INST_RS;
        IDEX_inst_Rt <= IFID_INST_RT;
        IDEX_inst_Rd <= IFID_INST_RD;
    end
    
    // Forward
    wire fEX_A = EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_inst_Rs;
    wire fEX_B = EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_inst_Rt;
    wire fMEM_A = 
        MEMWB_REGWRITE & MEMWB_dstReg != 0 & 
        !(EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg != IDEX_inst_Rs) &
        MEMWB_dstReg == IDEX_inst_Rs;
    wire fMEM_B = 
        MEMWB_REGWRITE & MEMWB_dstReg != 0 & 
        !(EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg != IDEX_inst_Rt) &
        MEMWB_dstReg == IDEX_inst_Rt;
        
    // EX
    wire [31:0] ALU_SRC_A = fEX_A ? EXMEM_aluRes : fMEM_A ? REG_WRITE_DATA : IDEX_readData1;
    wire [31:0] ALU_SRC_B = IDEX_ALUSRC ? IDEX_IMMSext : fEX_B ? EXMEM_aluRes : fEX_B ? EXMEM_aluRes : fMEM_B ? REG_WRITE_DATA : IDEX_readData2;
    wire [31:0] MEM_WRITE_DATA = fEX_B ? EXMEM_aluRes : fEX_B ? EXMEM_aluRes : fMEM_B ? REG_WRITE_DATA : IDEX_readData2;
         
   
    ALUCtr aluCtr(
        .Funct(IDEX_IMMSext[5:0]), 
        .ALUOp(IDEX_ALUOP), 
        .ALUCtrOut(ALU_CTRL_OUT)
    );
    
    ALU alu(
        .input1(ALU_SRC_A), 
        .input2(ALU_SRC_B), 
        .aluCtr(ALU_CTRL_OUT), 
        .zero(ZERO),
        .aluRes(ALU_RES)
    );
    
    mux5 DstRegMux(
        .sel(IDEX_REGDST),
        .input1(IDEX_inst_Rd),
        .input2(IDEX_inst_Rt), 
        .out(DST_REG));
        
    always @ (posedge clk)
    begin
        EXMEM_Ctr <= IDEX_Ctr[4:0];
        EXMEM_zero <= ZERO;
        EXMEM_aluRes <= ALU_RES;
        EXMEM_writeData <= MEM_WRITE_DATA;
        EXMEM_dstReg <= DST_REG;
    end
    
    // MEM
    wire [31:0] MEM_READ_DATA;
    
    dataMemory dataMem(
        .Clk(clk), 
        .address(EXMEM_aluRes), 
        .writeData(EXMEM_writeData), 
        .memRead(EXMEM_MEMREAD), 
        .memWrite(EXMEM_MEMWRITE), 
        .readData(MEM_READ_DATA)
    );
        
    always @ (posedge clk)
    begin
        MEMWB_Ctr <= EXMEM_Ctr[1:0];
        MEMWB_readData <= MEM_READ_DATA;
        MEMWB_aluRes <= EXMEM_aluRes;
        MEMWB_dstReg <= EXMEM_dstReg;
    end
    
    // WB
    mux32 writeDataMux(
        .sel(MEMWB_MEMTOREG), 
        .input1(MEMWB_readData), 
        .input2(MEMWB_aluRes), 
        .out(REG_WRITE_DATA));
        
    always @ (reset)
    begin
        PC = 0;
        IFID_pcPlus4 = 0;
        IFID_inst = 0;
        IDEX_inst_Rs = 0;
        IDEX_readData1 = 0;
        IDEX_readData2 = 0;
        IDEX_IMMSext = 0;
        IDEX_inst_Rt = 0;
        IDEX_inst_Rd = 0;
        IDEX_Ctr = 0;
        EXMEM_aluRes = 0;
        EXMEM_writeData = 0;
        EXMEM_dstReg = 0;
        EXMEM_Ctr = 0;
        EXMEM_zero = 0;
        MEMWB_readData = 0;
        MEMWB_aluRes = 0;
        MEMWB_dstReg = 0;
        MEMWB_Ctr = 0;
    end
    
endmodule

