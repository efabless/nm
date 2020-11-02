// CMtb_RBF_ASIC.v
// Copyright 2011-2020 General Vision Holding LLC

/***************** Open Source License Notice ************************

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

`timescale 1 ns / 100 ps // timescale for following modules

module NM500_test();

//Declaration of NeuroMem registers accessed by the Testbench CU
parameter CMNCR=5'h0;
parameter CMCOMP=5'h1;
parameter CMLCOMP=5'h2;
parameter CMDIST=5'h3;
parameter CMCAT=5'h4;
parameter CMAIF=5'h5;
parameter CMMINIF=5'h6;
parameter CMMAXIF=5'h7;
parameter CMALLCOMP=5'h8;
parameter CMALLCAT=5'h9;
parameter CMNID=5'hA;
parameter CMGCR=5'hB;
parameter CMRESETCHAIN=5'hC;
parameter CMNSR=5'hD;
parameter CMRSR=5'h1C;
parameter CMFORGET=5'hF;

wire ds_io, read_io;
wire id_,unclearn, ready;
pullup (id_), (unclearn),(ready); 

reg ds;
reg read;
reg [3:0]register;
reg [15:0]data;
reg [7:0]i=8'h00;

pulldown (ds_io);
assign ds_io=  ds;

pullup (read_io);
assign read_io= read;

wire [3:0]reg_io;
assign reg_io[3:0]= register[3:0];

tri1 [15:0]data_io;
assign data_io[15:0]= read ?16'hZZZZ:data[15:0];

reg [15:0]sm;
reg reset_l;
reg[7:0]error;
reg[7:0]G_error;

//----------------------------------------------------
// G_clock generation
//----------------------------------------------------
//parameter halfperiod = 18; // half of the clock period
parameter halfperiod = 10; // half of the clock period (50 MHz nominal)



reg clock;

always
begin
  #halfperiod; clock <= 1'b0 ; 
  #halfperiod; clock <= 1'b1 ; 
end

//----------------------------------------------------
// Single or multiple NeuroMem chip combination
//----------------------------------------------------
reg CS_n;
wire dco;
wire dc1;
nm_top nm1(.CS_l(CS_n),.G_CLK(clock), .G_RESET_l(reset_l), .DS(ds_io), .RW_l(read_io), .REG(reg_io), .DATA(data_io),.RDY(ready),
        .ID_l(id_), .UNC_l(unclearn),.DCI(1'b1), .DCO(DCO)); 

//nm_top nm2(.CS_l(CS_n),.G_CLK(clock), .G_RESET_l(reset_l), .DS(ds_io), .RW_l(read_io), .REG(reg_io), .DATA(data_io),.RDY(ready),
//        .ID_l(id_), .UNC_l(unclearn),.DCI(dc1), .DCO(dco)); 
//----------------------------------------------------
// Main test sequence
//----------------------------------------------------
parameter SM_TESTSR=20;
parameter SM_TESTRAMCHECKER=40;
parameter SM_TESTRAMBAR=60;
parameter SM_TESTRBF1=80;
parameter SM_TESTRBF2=100;
parameter SM_TESTRBF3=210;
parameter SM_TESTRBF4=240;
parameter SM_TESTEND=300;

parameter VECT1=16'h87A9;
parameter VECT2=16'h2345;
parameter VECT3=16'hBCDE;
parameter VECT4=16'hA9BD;


reg [15:0]ncount;
reg [15:0]ncount1;

initial
begin
//
// change testbench settings HERE
//
data[15:0]=16'h00;
clock <= 1'b0;  
sm[15:0]<=0; ncount[15:0]=16'h0000; ncount1[15:0]=16'h0000;
error[7:0]<=8'h00; G_error<=8'h00;

ds<=0;read<=1;read<=1; register[3:0]<=0;
reset_l <= 1'b0;
end

wire master_cu_ready= ready ;

wire tb_ready= master_cu_ready;
wire [15:0]tb_data_out;
assign tb_data_out= data_io;

always @(negedge clock)
case (sm[15:0])
    0:  begin reset_l<=0;CS_n<=1'b1;
        $display("-------------------------------------");
        sm<=sm+1; end
    1:  begin reset_l<=1; sm<=sm+1;CS_n<=1'b1; end

//----------------------------------------
// Count Neurons
//----------------------------------------
    2: if (tb_ready) begin
        $display("Neuron Count Test");
        tb_write(CMFORGET,16'h0000); sm<=sm+1; end
    //3:  if (tb_ready) begin tb_read(CMMINIF); sm<=sm+1; end
    3:  if (tb_ready) begin tb_write(CMNSR,16'h0010); sm<=sm+1; end
    4:  if (tb_ready) begin tb_write(CMALLCAT,16'h0001); sm<=sm+1; end
    5:  if (tb_ready) begin tb_write(CMRESETCHAIN,16'h0001); ncount[15:0]<=16'h0000; sm<=sm+1; end
    6:  if (tb_ready) begin tb_read(CMCAT); sm<=sm+1; end
    7:  if (tb_ready)
            if (tb_data_out[15:0]==16'h0001)
            begin ncount[15:0]<=ncount[15:0]+1; sm<=sm-1; end
            else sm<=sm+1;
    8:  if (tb_ready)
        begin 
        $display("%d : neurons= %d",$time,ncount);
        tb_write(CMNSR,16'h0000); sm<=sm+1; end
    9:  if (tb_ready) begin tb_write(CMFORGET,16'h0000); sm<=sm+1; end
//----------------------------------------
// Set parallel o
//----------------------------------------
    10: begin
        $display("-------------------------------------");
        sm<=SM_TESTRBF1;end

//----------------------------------------
//Test RBF #1 learning of slope vectors with 1st comp shifted by 2
//Enter test vector recognized by neuron 1 and neuron 2
//Interrupt operation with standby mode for 3 cc
//----------------------------------------
    80: if (tb_ready) 
        begin
        $display("RBF Test 1");
        tb_write(CMFORGET,16'h0000); error<=0; sm<=sm+1;
        end
    81: if (tb_ready) begin tb_write(CMMINIF,16'h0002); sm<=sm+1; end
    82: if (tb_ready)
            begin
            for (i=1;i<4;i=i+1) begin putslope(i[7:0]<<1,8'h08,{8'h00,i[7:0]});end
            sm<=sm+1;
            end
    83: if (tb_ready ) begin putslope(8'h03,8'h08,16'h0000);sm<=sm+1; end
    84: if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    85: if (tb_ready) begin
            $display("DIST= %h, expecting 8",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0008)error<=sm;
            sm<=sm+1; end   
    86: if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    87: if (tb_ready) begin
            $display("CAT= %h, expecting 1",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0001)error<=sm;
            sm<=sm+1; end   
    88: if (tb_ready ) begin tb_read(CMDIST);sm<=sm+1; end
    89: if (tb_ready) begin
            $display("DIST= %h, expecting 8",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0008)error<=sm;
            sm<=sm+1; end   
    90: if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    91: if (tb_ready) begin
            $display("CAT= %h, expecting 2",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0002)error<=sm;
            sm<=sm+1; end
    92: if (tb_ready ) begin putslope(8'h02,8'h08,16'h0000);sm<=sm+1; end
    93:	if (tb_ready) begin tb_read(CMNSR); sm<=sm+1; end
    94:	if (tb_ready) begin
            $display("CSR= %h, expecting identified status 8",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0008) error<=sm;
            sm<=sm+1; end
    95:     begin
            $display("%d : Results: Error %d",$time,error);
            $display("-------------------------------------");
            if (error !=0) G_error<=G_error+1;
            CS_n<=1'b1; sm<=sm+1; end
    96:    sm<=sm+1;
    97:    sm<=sm+1;
    98:    begin CS_n<=1'b0; sm<=SM_TESTRBF2; end

//----------------------------------------
//Test RBF  #2 learning and recognition
//
//LEARN     Vector1     Vector2    Vector3
//Context   1           1           1
//Comp      87A9        2345        BCDE
//Cat       11          0           13
//
//RECO      Vector4
//Context   1
//Comp      A9BD
//Dist      9                       7
//----------------------------------------
    100:	if (tb_ready) 
            begin
            $display("RBF Test2");
            tb_write(CMFORGET,{16'h0000}); error<=0; sm<=sm+1;
            end
    101:	if (tb_ready) begin PutVect4(VECT1,8'h1); sm<=sm+1; end
    102:	if (tb_ready) begin tb_write(CMCAT,16'h0011); sm<=sm+1; end
    103:	if (tb_ready) begin PutVect4(VECT2,8'h1); sm<=sm+1; end
    104:	if (tb_ready) begin tb_write(CMCAT,16'h0000); sm<=sm+1; end
    105:	if (tb_ready) begin PutVect4(VECT3,8'h1); sm<=sm+1; end
    106:	if (tb_ready) begin tb_write(CMCAT,16'h0013); sm<=sm+1; end
    107:	if (tb_ready) begin PutVect4(VECT4,8'h1); sm<=sm+1; end
    108:	if (tb_ready) begin tb_read(CMNSR); sm<=sm+1; end
    109:	if (tb_ready) begin
            $display("CSR= %h, expecting uncertain status 4",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0004) error<=sm;
            sm<=sm+1; end
    110:	if (tb_ready) begin tb_read(CMFORGET);sm<=sm+1; end
    111:	if (tb_ready) begin
            $display("NCOUNT= %h, expecting 2 neurons",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0002) error<=sm;
            sm<=sm+1; end
    112:	begin
        $display("%d : Results: Error %d",$time,error);
        $display("-------------------------------------");
        if (error !=0) G_error<=G_error+1;
        //sm<=SM_TESTEND; end
        sm<=SM_TESTRBF3; end
//----------------------------------------
//Test RBF learning and recognition
// Similar to Test RBF1 but with different context
//
//LEARN     Vector1     Vector2    Vector3
//Context   1           2           3
//Comp      87A9        2345        BCDE
//Cat       11          12          13
//
//RECO      Vector4
//Context   1
//Comp      A9BD
//Dist      9           na          na

//RECO      Vector4
//Context   3
//Comp      A9BD
//Dist      na           na          7

//RECO      Vector4
//Context   0
//Comp      A9BD
//Dist      9            na          7

//----------------------------------------
    210:	if (tb_ready) 
            begin
            $display("RBF Test3 with mixed context values");
            tb_write(CMFORGET,{16'h0000}); error<=0; sm<=sm+1;
            end
    211:	if (tb_ready) begin PutVect4(VECT1,8'h1); sm<=sm+1; end
    212:	if (tb_ready) begin tb_write(CMCAT,16'h0011); sm<=sm+1; end
    213:	if (tb_ready) begin PutVect4(VECT2,8'h2); sm<=sm+1; end
    214:	if (tb_ready) begin tb_write(CMCAT,16'h0000); sm<=sm+1; end
    215:	if (tb_ready) begin PutVect4(VECT3,8'h3); sm<=sm+1; end
    216:	if (tb_ready) begin tb_write(CMCAT,16'h0013); sm<=sm+1; end
    217:	if (tb_ready) begin PutVect4(VECT4,8'h1); sm<=sm+1; end
    218:	if (tb_ready) begin tb_read(CMNSR); sm<=sm+1; end
    219:	if (tb_ready) begin
            $display("CSR= %h, expecting identified status 8",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0008) error<=sm;
            sm<=sm+1; end
    220:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    221:    if (tb_ready) begin
            $display("CAT= %h, expecting 11",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0011)error<=sm;
            sm<=sm+1; end
    222:	if (tb_ready) begin PutVect4(VECT4,8'h3); sm<=sm+1; end
    223:	if (tb_ready) begin tb_read(CMNSR); sm<=sm+1; end
    224:	if (tb_ready) begin
            $display("CSR= %h, expecting identified status 8",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0008) error<=sm;
            sm<=sm+1; end
    225:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    226:    if (tb_ready) begin
            $display("CAT= %h, expecting 13",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0013)error<=sm;
            sm<=sm+1; end
    227:	if (tb_ready) begin PutVect4(VECT4,8'h0); sm<=sm+1; end
    228:	if (tb_ready) begin tb_read(CMNSR); sm<=sm+1; end
    229:	if (tb_ready) begin
            $display("CSR= %h, expecting uncertain status 4",tb_data_out[15:0]); 
            if (tb_data_out[15:0]!=16'h0004) error<=sm;
            sm<=sm+1; end
    230:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    231:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    232:    if (tb_ready) begin
            $display("CAT= %h, expecting 13",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0013)error<=sm;
            sm<=sm+1; end
    233:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    234:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    235:    if (tb_ready) begin
            $display("CAT= %h, expecting 11",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0011)error<=sm;
            sm<=sm+1; end
    236:	begin
            $display("%d : Results: Error %d",$time,error);
            $display("-------------------------------------");
            if (error !=0) G_error<=G_error+1;
            sm<=SM_TESTRBF4; end

//----------------------------------------
//Test RBF learning and recognition
// Similar to Test RBF1 but with different context
//
//LEARN     Vector1     Vector2    Vector3
//Context   1           2           3
//Comp      87A9        2345        BCDE
//Cat       11          12          13
//
//RECO      Vector4
//Context   1
//Comp      A9BD
//Dist      9           na          na

//RECO      Vector4
//Context   3
//Comp      A9BD
//Dist      na           na          7

//RECO      Vector4
//Context   0
//Comp      A9BD
//Dist      9            na          7

//----------------------------------------
    240:	if (tb_ready) 
            begin
            $display("RBF Test4, testing degenerated flags");
            tb_write(CMFORGET,{16'h0000}); error<=0; sm<=sm+1;
            end
    241:	if (tb_ready) begin tb_write(CMMINIF, 16'h0012); sm<=sm+1; end
    242:	if (tb_ready) begin PutVect4(VECT1,8'h1); sm<=sm+1; end
    243:	if (tb_ready) begin tb_write(CMCAT,16'h0011); sm<=sm+1; end
    244:	if (tb_ready) begin PutVect4(VECT2,8'h1); sm<=sm+1; end
    245:	if (tb_ready) begin tb_write(CMCAT,16'h0012); sm<=sm+1; end
    246:	if (tb_ready) begin PutVect4(VECT3,8'h1); sm<=sm+1; end
    247:	if (tb_ready) begin tb_write(CMCAT,16'h0013); sm<=sm+1; end
    248:	if (tb_ready) begin PutVect4(VECT4,8'h1); sm<=sm+1; end
    249:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    250:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    251:    if (tb_ready) begin
            $display("CAT= %h, expecting 8013",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h8013)error<=sm;
            sm<=sm+1; end
    252:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    253:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    254:    if (tb_ready) begin
            $display("CAT= %h, expecting 8011",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h8011)error<=sm;
            sm<=sm+1; end
    255:	if (tb_ready) begin PutVect4(VECT2,8'h1); sm<=sm+1; end
    256:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    257:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    258:    if (tb_ready) begin
            $display("CAT= %h, expecting 0012",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h0012)error<=sm;
            sm<=sm+1; end
    259:	if (tb_ready) begin tb_write(CMMINIF, 16'h0008); sm<=sm+1; end
    260:	if (tb_ready) begin PutVect4(16'h3456,8'h1); sm<=sm+1; end
    261:	if (tb_ready) begin tb_write(CMCAT,16'h0000); sm<=sm+1; end
    262:	if (tb_ready) begin PutVect4(VECT2,8'h1); sm<=sm+1; end
    263:	if (tb_ready) begin tb_read(CMDIST);sm<=sm+1; end
    264:	if (tb_ready) begin tb_read(CMCAT);sm<=sm+1; end
    265:    if (tb_ready) begin
            $display("CAT= %h, expecting 8012",tb_data_out[15:0]); 
            if(tb_data_out[15:0]!=16'h8012)error<=sm;
            sm<=sm+1; end
    266:	begin
            $display("%d : Results: Error %d",$time,error);
            $display("-------------------------------------");
            if (error !=0) G_error<=G_error+1;
            //sm<=SM_TESTRBF2; end
            sm<=SM_TESTEND; end

//----------------------------------------
// THE END....if G_Error=0!!!!!
//----------------------------------------
    300:    begin
            $display("TOTAL TEST ERRORS: ", G_error);
            $finish;   
            end
endcase



//SUBSIDIARY FUNCTIONS USED BY ABOVE TEST ROUTINES


/*******************************************
Write function from the testbench cu 
*******************************************/
task tb_write;
input [4:0]register_in;
input [15:0]data_in;
begin
@(negedge clock)begin CS_n<=1'b0;ds<=1;read<=0;register[3:0]<=register_in[3:0]; data[15:0]<=data_in[15:0];end
@(negedge clock)begin ds<=0;read<=1;end
while (~tb_ready) @(negedge clock)begin ds<=0;read<=1;end
@(negedge clock);CS_n<=1'b1;
end
endtask

/*******************************************
Read function from the testbench cu
*******************************************/
task tb_read;
input [3:0]register_in;
begin
@(negedge clock) begin CS_n<=1'b0;ds<=1;read<=1;register[3:0]<=register_in[3:0];end
@(negedge clock)ds<=0;
while (~tb_ready) @(negedge clock)ds<=0;
@(negedge clock);CS_n<=1'b1;
end
endtask


/*****************************************************************
Broadcast a vector in normal mode
including its context and 4 components decoded from a 16-bit value
******************************************************************/
task PutVect4;
input [15:0]vectordata;
input [7:0]context;
	begin
    tb_write(CMGCR,{8'h00,context[7:0]});
	tb_write(CMCOMP, {12'h000,vectordata[15:12]});
	tb_write(CMCOMP, {12'h000,vectordata[11:8]});
	tb_write(CMCOMP, {12'h000,vectordata[7:4]});
	tb_write(CMLCOMP,{12'h000,vectordata[3:0]});
	end
endtask

/*****************************************************************
Broadcast a vector in normal mode
including its context and 4 components decoded from a 16-bit value
******************************************************************/
task putslope;
input [7:0]offsetdata;
input [7:0]veclen;
input [15:0]learncat;
reg [7:0]j;
begin
    for (j=0;j<(veclen-1);j=j+1)
        begin
        //@(negedge clock); tb_write(CMCOMP,{8'h00,offsetdata[7:0]}+{8'h00,j});
        @(negedge clock) tb_write(CMCOMP,{8'h00,offsetdata[7:0]}+{8'h00,j});
        end
	@(negedge clock) tb_write(CMLCOMP,{8'h00,offsetdata[7:0]}+{8'h00,j});
    for (j=0;j<3;j=j+1) @(negedge clock) ds<=0;
    if (learncat[15:0]!=16'h0000) tb_write(CMCAT,learncat[15:0]);
    for (j=0;j<19;j=j+1) @(negedge clock) ds<=0;
end
endtask


endmodule
