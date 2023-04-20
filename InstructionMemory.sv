module InstructionMemory(input logic [31:0] addr, 
                         output logic [31:0] instruction);
    logic [31:0] instruction_memory [31:0];    
    initial begin
        $readmemh("PATH", instruction_memory);  // Put the absolute path of the machine code that you want to execute. In our case "code.mem".
    end
    assign instruction = instruction_memory[addr[31:2]];
endmodule
