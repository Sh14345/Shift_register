module tb;
  reg si,clk,rst;
  wire so;
  
  reg exp_arr[$];
  reg dut_arr[$];
  reg [3:0] mismatched,matched;
  
  
  siso dut(si,clk,rst,so);
  
  initial begin 
    mismatched = 4'd0;
    matched = 4'd0;
    
    rst = 0; clk =1;
    #10 rst =1;
    #10 rst = 0;
   
//     exp_arr.push_back(si);
//     #10 si=1;exp_arr.push_back(si);
    
//     #10 si =1;exp_arr.push_back(si);
//     #10 si = 0;exp_arr.push_back(si);
    @(posedge clk); si = 1; exp_arr.push_back(si);
    @(posedge clk); si = 0; exp_arr.push_back(si);
    @(posedge clk); si = 1; exp_arr.push_back(si);
    @(posedge clk); si = 1; exp_arr.push_back(si);
    @(posedge clk); si = 0; exp_arr.push_back(si); 
    // Add some idle cycles for the last bits to propagate
    repeat(4) @(posedge clk); 
    $display("exp values = %p",exp_arr);
    compare();
    $display("act values = %p",dut_arr);
    
    results();
    
   
   #150 $finish;
  end
  
  always #5 clk = !clk;
 
  
  always@(posedge clk) begin
   
   
    repeat (5) @(posedge clk);
    
    for (int i = 0; i < exp_arr.size(); i++) begin
      @(posedge clk);
      dut_arr.push_back(so);
    end
    

  end
  
    
    task compare();
 

      
      if(exp_arr.size() > 0 && dut_arr.size() > 0)
      begin
        for(int i=0; i< dut_arr.size() ; i++) begin
        if(exp_arr[i] == dut_arr[i]) begin
          matched++;
          $display($time,"[matched] the expected = %0b, actual =%0b in clock of i =%0d",exp_arr[i], dut_arr[i],i);
        end
        else 
          begin
        	mismatched++;
            $display($time,"[mismatched] the expected =%0b , actual = %0b in the clock of i =%0d",exp_arr[i], dut_arr[i],i);
            
          end
        
      end
      end
    endtask
    
      
    task results();
    $display("\n****************************");
    $display("Matched count=%0d",matched);
    $display("Mis_Matched count=%0d",mismatched);
    
    if(mismatched == 0)
      $display("\n***************Test passed****************");
    else
      $display("\n*************Test Failed******************");
    
    $display("\n************************************");
  endtask
      
      
      
    
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    $monitor($time,"The lsb value is si= %0b & the output is so=%0b",si,so);
    
  end
endmodule
