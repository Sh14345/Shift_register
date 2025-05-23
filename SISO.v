module siso( input si, clk, rst, output so);
  reg [3:0]temp;
  
  always@(posedge clk) begin
    if(rst) begin
      temp <= 4'b0000;
    end
    else 
      begin
      temp <= temp >>1;
      temp[3] <= si;
      end
  end
  
  assign so = temp[0];
     
endmodule
      
