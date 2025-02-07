`timescale 1ns/1ps 
module testbench; 

// localparam
localparam N = 10000; // testdata numbers
localparam CYCLE = 10;

// input signal use reg
reg [13:0] binary_in;

// output signal use wire
wire [15:0] packed_bcd_out;

// interger 
integer i, j, error;

///// instantiate  module /////
binary2bcd binary2bcd(
  .binary_in(binary_in),
  .packed_bcd_out(packed_bcd_out)
);

// dump the waveform of the simulation for vcd//
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars("+mda");
end

task binary2bcd_software;
    input reg [13:0] task_binary_in;
    output reg [15:0] task_bcd_out;
    reg [13:0] task_binary_in_tmp;
    reg [3:0] digit[0:3];

  begin 
    task_binary_in_tmp = task_binary_in;
    for (j = 0; j < 4; j = j + 1) begin
      digit[j] = task_binary_in_tmp % 10;
      task_binary_in_tmp = task_binary_in_tmp / 10;
    end
    task_bcd_out = {digit[3], digit[2], digit[1], digit[0]};
  end
endtask


reg [13:0] testdata; //test input binary
reg [15:0] packed_bcd_sw; // correct answer
integer fp_w;

initial begin
  error = 0;
  fp_w = $fopen("answer.txt");

  #(CYCLE);

  for (i=0; i<N; i=i+1) begin
    testdata = i;
    binary_in = testdata;
    binary2bcd_software(testdata, packed_bcd_sw);
    
    #(CYCLE/2);
    
    if (packed_bcd_out !== packed_bcd_sw) begin
      error = error + 1;
      $display("************* Pattern No.%d is wrong at %t ************", i, $time);
      $display("Input Binary = %b, correct answer is %b, but your answer is %b !", testdata, packed_bcd_sw, packed_bcd_out);   
    end
    $fdisplay(fp_w, "%b_%b_%b", testdata, packed_bcd_out, packed_bcd_sw);

    #(CYCLE/2);
  end
  $fclose(fp_w);

  if (error == 0) begin
    $display("Your binary2bcd is correct!!");
  end else begin
    $display("error !!");
  end
  #(CYCLE);
  $finish;
end

endmodule