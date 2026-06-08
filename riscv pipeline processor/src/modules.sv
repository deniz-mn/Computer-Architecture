`timescale 1ns/1ns
`define ALU_SUB 3'b001
`define ALU_ADD 3'b000
`define ALU_XOR 3'b100
`define ALU_AND 3'b010
`define ALU_OR 3'b011
`define ALU_SLT 3'b101

module ALU(in1, in2, sl, out, zero, sign);
        input [31:0] in1, in2;
        input [2:0] sl;
        output zero, sign;
        output reg [31:0] out;

        always @(in1, in2, sl) begin
                out = 32'b0;
                case (sl)
                        `ALU_ADD:
                                out = in1 + in2;
                        `ALU_SUB:
                                out = in1 - in2;
                        `ALU_AND:
                                out = in1 & in2;
                        `ALU_OR:
                                out = in1 | in2;
                        `ALU_XOR:
                                out = in1 ^ in2;
                        `ALU_SLT:
                                out = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;
                        default: out = 32'b0;
                endcase
        end

        assign zero = (out == 32'b0);
        assign sign = (out[31]);
endmodule


module adder32B(in1, in2, sum, c);
        input [31:0] in1, in2;
        output [31:0] sum;
        output c;     
        assign {c, sum} = in1 + in2;
endmodule



module dataMemory(clk, rst, A, WE, WD, RD);
        input clk, rst;
        input [31:0] A;
        input WE;
        input [31:0] WD;
        output [31:0] RD;
        wire [31:0] mem_addr;
        integer i;

        reg [31:0] memory [0:16384];

        initial begin
                // $readmemb("temp.txt", memory);
                $readmemb("data/array.txt", memory);
        end

        assign mem_addr = {2'b0, A[31:2]};

        always @(posedge clk, posedge rst) begin
                if (WE) begin
                        memory[mem_addr] <= WD;
                end
        end
        
        assign RD = memory[mem_addr];
endmodule


module extend(inst, sl, out);
        input [31:7] inst;
        input [2:0] sl;
        output [31:0] out;
        
        assign out = 
                sl == 3'b000 ? {{21{inst[31]}}, inst[30:20]} : // I-Type
                sl == 3'b001 ? {{21{inst[31]}}, inst[30:25], inst[11:7]} : // S-Type
                sl == 3'b010 ? {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0} : // B-Type
                sl == 3'b100 ? {inst[31], inst[30:20], inst[19:12], 12'b0} : // U-Type
                sl == 3'b011 ?  {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0} : // J-Type
                32'bx;
endmodule

module hazardUnit(rst, RegWriteWHazard, RdWHazard, RegWriteMHazard, RdMHazard, ResultSrcEHazard, PCSrcEHazard,
                 Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard,
                        FlushE, FlushD, StallD, StallF, ForwardBE, ForwardAE);
        input RegWriteWHazard, RegWriteMHazard;
        input [1:0] ResultSrcEHazard;
        input [1:0] PCSrcEHazard;
        output reg FlushE, FlushD, StallD, StallF;
        output reg [1:0] ForwardBE, ForwardAE;
      //   input [4:0] Rs1EHazard, Rs2EHazard;
        input [4:0] RdWHazard, RdMHazard, Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard;
      input rst;
reg lwStall;

always @(posedge rst) {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;
always @(Rs1DHazard, Rs2DHazard, Rs1EHazard, Rs2EHazard, RdEHazard, ResultSrcEHazard, RdMHazard, RegWriteMHazard, RdWHazard, RegWriteWHazard) begin
    
    {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;

    if(((Rs1EHazard == RdMHazard) && RegWriteMHazard) && (Rs1EHazard != 5'b00000))
        ForwardAE = 2'b10;
    else if (((Rs1EHazard == RdWHazard) && RegWriteWHazard) && (Rs1EHazard != 5'b00000))
        ForwardAE = 2'b01;
    else 
        ForwardAE = 2'b00;

    if(((Rs2EHazard == RdMHazard) && RegWriteMHazard) && (Rs2EHazard != 5'b00000))
        ForwardBE = 2'b10;
    else if (((Rs2EHazard == RdWHazard) && RegWriteWHazard) && (Rs2EHazard != 5'b00000))
        ForwardBE = 2'b01;
    else 
        ForwardBE = 2'b00;

    if (((Rs1DHazard == RdEHazard) || (Rs2DHazard == RdEHazard)) && (ResultSrcEHazard == 2'b01))
        {lwStall,StallD, StallF} = 3'b111;
        
end

assign FlushD = |PCSrcEHazard;
assign FlushE = (lwStall || |PCSrcEHazard);
    
endmodule


module instructionMemory(A, RD);
        input [31:0] A;
        output [31:0] RD;
        wire [31:0] mem_addr;

        reg [31:0] memory [0:16384];
        initial begin
                $readmemb("data/instructions.txt", memory);
        end

        assign mem_addr = {2'b0, A[31:2]};
        assign RD = memory[mem_addr];
endmodule


module mux2To1(in0, in1, sl, out);
        input [31:0] in0, in1;
        input sl;
        output [31:0] out;
        
        assign out = sl ? in1 : in0; 
endmodule



module mux4To1(in0, in1, in2, in3, sl, out);
        input [31:0] in0, in1, in2, in3;
        input [1:0] sl;
        output [31:0] out;
        
        assign out =
                sl == 2'b00 ? in0 :
                sl == 2'b01 ? in1 :
                sl == 2'b10 ? in2 :
                sl == 2'b11 ? in3 :
                32'bx;
endmodule


module pipeDE(clk, rst, clr, 
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, LUIInstrD,
                RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ExtImmD, PCPlus4D,
                RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, LUIInstrE,
                RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ExtImmE, PCPlus4E);
        
        input clk, rst, clr;
        input RegWriteD, MemWriteD, ALUSrcD, LUIInstrD;
        input [1:0] ResultSrcD, JumpD;
        input [2:0] ALUControlD, BranchD;
        input [4:0] Rs1D, Rs2D, RdD;
        input [31:0] RD1D, RD2D, PCD, ExtImmD, PCPlus4D;
        output   RegWriteE, MemWriteE, ALUSrcE, LUIInstrE;
        output   [1:0] ResultSrcE, JumpE;
        output   [2:0] ALUControlE, BranchE;
        output   [4:0] Rs1E, Rs2E, RdE;
        output   [31:0] RD1E, RD2E, PCE, ExtImmE, PCPlus4E;

        regPipe #(1) regWriteReg(clk, rst, clr, 1'b1, RegWriteD, RegWriteE);
        regPipe #(1) memWriteReg(clk, rst, clr, 1'b1, MemWriteD, MemWriteE);
        regPipe #(1) ALUSrcReg(clk, rst, clr, 1'b1, ALUSrcD, ALUSrcE);
        regPipe #(1) luiReg(clk, rst, clr, 1'b1, LUIInstrD, LUIInstrE);
        regPipe #(2) jumpReg(clk, rst, clr, 1'b1, JumpD, JumpE);
        regPipe #(2) resultSrcReg(clk, rst, clr, 1'b1, ResultSrcD, ResultSrcE);
        regPipe #(3) branchReg(clk, rst, clr, 1'b1, BranchD, BranchE);
        regPipe #(3) ALUControlReg(clk, rst, clr, 1'b1, ALUControlD, ALUControlE);

        regPipe #(5) Rs1Reg(clk, rst, clr, 1'b1, Rs1D, Rs1E);
        regPipe #(5) Rs2Reg(clk, rst, clr, 1'b1, Rs2D, Rs2E);
        regPipe #(5) Rd3Reg(clk, rst, clr, 1'b1, RdD, RdE);
        regPipe #(32) RD1Reg(clk, rst, clr, 1'b1, RD1D, RD1E);
        regPipe #(32) RD2Reg(clk, rst, clr, 1'b1, RD2D, RD2E);
        regPipe #(32) PCReg(clk, rst, clr, 1'b1, PCD, PCE);
        regPipe #(32) extImmReg(clk, rst, clr, 1'b1, ExtImmD, ExtImmE);
        regPipe #(32) pcPlus4Reg(clk, rst, clr, 1'b1, PCPlus4D, PCPlus4E);
endmodule

module pipeEM(clk, rst,
                RegWriteE, ResultSrcE, MemWriteE, LUIInstrE,
                ALUResultE, WriteDataE, RdE, ExtImmE, PCPlus4E,
                RegWriteM, ResultSrcM, MemWriteM, LUIInstrM,
                ALUResultM, WriteDataM, RdM, ExtImmM, PCPlus4M);
        
        input clk, rst;
        input RegWriteE, MemWriteE, LUIInstrE;
        input [1:0] ResultSrcE;
        input [4:0] RdE;
        input [31:0] ALUResultE, WriteDataE, ExtImmE, PCPlus4E;
        output  RegWriteM, MemWriteM, LUIInstrM;
        output  [1:0] ResultSrcM;
        output   [4:0] RdM;
        output   [31:0] ALUResultM, WriteDataM, ExtImmM, PCPlus4M;
	
        regPipe #(1) regWriteReg(clk, rst, 1'b0, 1'b1, RegWriteE, RegWriteM);
        regPipe #(1) memWriteReg(clk, rst, 1'b0, 1'b1, MemWriteE, MemWriteM);
        regPipe #(1) luiReg(clk, rst, 1'b0, 1'b1, LUIInstrE, LUIInstrM);
        regPipe #(2) resultSrcReg(clk, rst, 1'b0, 1'b1, ResultSrcE, ResultSrcM);

        regPipe #(5) RdReg(clk, rst, 1'b0, 1'b1, RdE, RdM);
        regPipe #(32) ALUResultReg(clk, rst, 1'b0, 1'b1, ALUResultE, ALUResultM);
        regPipe #(32) writeDataReg(clk, rst, 1'b0, 1'b1, WriteDataE, WriteDataM);
        regPipe #(32) extImmReg(clk, rst, 1'b0, 1'b1, ExtImmE, ExtImmM);
        regPipe #(32) pcPlus4Reg(clk, rst, 1'b0, 1'b1, PCPlus4E, PCPlus4M);
endmodule


module pipeFD(clk, rst, en, clr, 
                InstrF, PCF, PCPlus4F, 
                InstrD, PCD, PCPlus4D);
        input clk, rst, en, clr;
        input [31:0] InstrF, PCF, PCPlus4F;
        output [31:0] InstrD, PCD, PCPlus4D;
	
        regPipe #(32) instrReg(clk, rst, clr, en, InstrF, InstrD);
        regPipe #(32) pcReg(clk, rst, clr, en, PCF, PCD);
        regPipe #(32) pcPlus4Reg(clk, rst, clr, en, PCPlus4F, PCPlus4D);
endmodule


module pipeMW(clk, rst,
                RegWriteM, ResultSrcM,
                ReadDataM, RdM, ExtImmM, PCPlus4M, ALUResultM,
                RegWriteW, ResultSrcW,
                ReadDataW, RdW, ExtImmW, PCPlus4W, ALUResultW);
        
        input clk, rst;
        input RegWriteM;
        input [1:0] ResultSrcM;
        input [4:0] RdM;
        input [31:0] ReadDataM, ExtImmM, PCPlus4M, ALUResultM;
        output  RegWriteW;
        output [1:0] ResultSrcW;
        output [4:0] RdW;
        output  [31:0] ReadDataW, ExtImmW, PCPlus4W, ALUResultW;
	
        regPipe #(1) regWriteReg(clk, rst, 1'b0, 1'b1, RegWriteM, RegWriteW);
        regPipe #(2) resultSrcReg(clk, rst, 1'b0, 1'b1, ResultSrcM, ResultSrcW);

        regPipe #(5) RdReg(clk, rst, 1'b0, 1'b1, RdM, RdW);
        regPipe #(32) readDataReg(clk, rst, 1'b0, 1'b1, ReadDataM, ReadDataW);
        regPipe #(32) extImmReg(clk, rst, 1'b0, 1'b1, ExtImmM, ExtImmW);
        regPipe #(32) ALUResReg(clk, rst, 1'b0, 1'b1, ALUResultM, ALUResultW);
        regPipe #(32) pcPlus4Reg(clk, rst, 1'b0, 1'b1, PCPlus4M, PCPlus4W);
endmodule


module reg32B(clk, rst, en, dataIn, dataOut);
        input clk, rst, en;
        input [31:0] dataIn;
        output [31:0] dataOut;
        reg [31:0] savedData;
        
        always @(posedge clk, posedge rst) begin 
                if (rst) 
                        savedData = 32'b0;

                else if (en)
                        savedData = dataIn;
        end

        assign dataOut = savedData;
endmodule



module regPipe(clk, rst, clr, en, dataIn, dataOut);
        parameter SIZE;
        input clk, rst, clr, en;
        input [SIZE-1:0] dataIn;
        output [SIZE-1:0] dataOut;
        reg [SIZE-1:0] savedData;
        
        always @(posedge clk, posedge rst) begin 
                if (rst) 
                        savedData = 0;
                else if (clr)
                        savedData = 0;
                else if (en)
                        savedData = dataIn;
        end

        assign dataOut = savedData;
endmodule



module registerFile(clk, rst, A1, A2, A3, WE, WD, RD1, RD2);
        input clk, rst;
        input [4:0] A1;
        input [4:0] A2;
        input [4:0] A3;
        input WE;
        input [31:0] WD;
        output [31:0] RD1, RD2;
        integer i;
        
        reg [31:0] registers [0:31];
        initial begin
                registers[0] <= 32'b0; // ZERO register
        end

        always @(negedge clk, posedge rst) begin
                if (rst) begin
                        for (i = 0; i < 32; i = i + 1)
                                registers[i] = 32'b0;
                end
                else if (WE && A3 != 5'b0) begin
                        registers[A3] = WD;
                end
        end
        assign RD1 = registers[A1];
        assign RD2 = registers[A2];
        integer j;
        always @(posedge clk) begin
                $display("RF| max in x8: ", registers[8], ",   i in x6: ", registers[6]);
        end
endmodule

