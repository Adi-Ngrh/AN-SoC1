module adder #(parameter OP_SIZE = 64, parameter LAYERS = 6) (
    input logic [OP_SIZE-1:0] op1,
    input logic [OP_SIZE-1:0] op2,
    output logic [OP_SIZE-1:0] sum,
    output logic carry_out
);

logic [OP_SIZE-1:0] carry; 
logic [OP_SIZE-1:0] G [0:LAYERS]; // 1 if a bit generate carry
logic [OP_SIZE-1:0] P [0:LAYERS]; // 1 if a bit propagate carry
logic [OP_SIZE-1:0] K [0:LAYERS]; // 1 if bit kill carry

always_comb begin
    carry = '0; // initialize to all 0
    G[0] = op1 & op2;
    P[0] = op1 ^ op2;
    K[0] = (~op1) & (~op2);
    for (int i = 0; i < LAYERS; i++) begin
        G[i+1] = G[i] | (P[i] & (G[i] << (1 << i)));
        K[i+1] = K[i] | (P[i] & (K[i] << (1 << i)));
        P[i+1] = P[i] & (P[i] << (1 << i));
    end
    carry = G[LAYERS] << 1;
    sum = (op1 ^ op2) ^ carry;
    carry_out = G[LAYERS][OP_SIZE-1];
end
endmodule