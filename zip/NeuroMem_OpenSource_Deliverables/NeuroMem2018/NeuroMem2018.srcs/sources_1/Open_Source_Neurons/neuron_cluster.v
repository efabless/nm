// neuron_cluster.v
// Copyright 2011-2020 General Vision Holdings.

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
// Cluster of 32 neurons

module neuroncluster (input clk, input reset_l, input ds, input read, input [3:0]register, input [15:0]data_in, input SR,input KNN, input oktolearn_in, input dci, 
output dco, output id, output unclearn, output [15:0]data_out, output ready);
//
// Ready lines tree
wire ready1, ready2, ready3, ready4, ready5, ready6, ready7, ready8, ready9, ready10,  ready11, ready12 , ready13, ready14, ready15, ready16,
ready17, ready18, ready19, ready20, ready21, ready22, ready23, ready24, ready25, ready26,  ready27, ready28 , ready29, ready30, ready31, ready32;
//
assign ready= ready1 & ready2 & ready3 & ready4 & ready5 & ready6 & ready7 & ready8 & ready9 & ready10 & ready11 & ready12 & ready13 & ready14 & ready15 & ready16 &
ready17 & ready18 & ready19 & ready20 & ready21 & ready22 & ready23 & ready24 & ready25 & ready26 & ready27 & ready28 & ready29 & ready30 & ready31 & ready32;
// Uncertain_learn lines tree
wire unclearn1, unclearn2,  unclearn3, unclearn4, unclearn5,  unclearn6, unclearn7, unclearn8, unclearn9, unclearn10, unclearn11, unclearn12, unclearn13, unclearn14, unclearn15, unclearn16, 
unclearn17, unclearn18,  unclearn19, unclearn20, unclearn21,  unclearn22, unclearn23, unclearn24, unclearn25, unclearn26, unclearn27, unclearn28, unclearn29, unclearn30, unclearn31, unclearn32; 
//
assign unclearn= unclearn1 & unclearn1 & unclearn2 & unclearn3 & unclearn4 & unclearn5 & unclearn6 & unclearn7 & unclearn8 & unclearn9 & unclearn10 & unclearn11 & unclearn12 & unclearn13 & unclearn14 & unclearn15 & unclearn16
& unclearn17 & unclearn18 & unclearn19 & unclearn20 & unclearn21 & unclearn22 & unclearn23 & unclearn24 & unclearn25 & unclearn26 & unclearn27 & unclearn28 & unclearn29 & unclearn30 & unclearn31 & unclearn32; 
// IDentified lines tree
wire id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, id14, id15, id16,
id17, id18, id19, id20, id21, id22, id23, id24, id25, id26, id27, id28, id29, id30, id31, id32;
//
assign id= id1 | id2 | id3 | id4 | id5 | id6 | id7 | id8 | id9 | id10 | id11 | id12 | id13 | id14 | id15 | id16 |
id17 | id18 | id19 | id20 | id21 | id22 | id23 | id24 | id25 | id26 | id27 | id28 | id29 | id30 | id31 | id32;
// DATA Output merge it perform the global AND of each neuron output in the cluster
wire [15:0]data_out1; wire [15:0]data_out2; wire [15:0]data_out3;wire [15:0]data_out4; wire [15:0]data_out5;wire [15:0]data_out6; wire [15:0]data_out7; wire [15:0]data_out8;
wire [15:0]data_out9; wire [15:0]data_out10;wire [15:0]data_out11; wire [15:0]data_out12;wire [15:0]data_out13; wire [15:0]data_out14;wire [15:0]data_out15;wire [15:0]data_out16;
wire [15:0]data_out17; wire [15:0]data_out18; wire [15:0]data_out19;wire [15:0]data_out20; wire [15:0]data_out21;wire [15:0]data_out22; wire [15:0]data_out23; wire [15:0]data_out24;
wire [15:0]data_out25; wire [15:0]data_out26;wire [15:0]data_out27; wire [15:0]data_out28;wire [15:0]data_out29; wire [15:0]data_out30;wire [15:0]data_out31;wire [15:0]data_out32;
//
assign data_out[15:0]= data_out1[15:0] & data_out2[15:0] & data_out3[15:0] & data_out4[15:0] & data_out5[15:0] & data_out6[15:0] & data_out7[15:0] & data_out8[15:0] & data_out9[15:0] 
& data_out10[15:0] & data_out11[15:0] & data_out12[15:0] & data_out13[15:0] & data_out14[15:0] & data_out15[15:0]& data_out16[15:0] &
data_out17[15:0] & data_out18[15:0] & data_out19[15:0] & data_out20[15:0] & data_out21[15:0] & data_out22[15:0] & data_out23[15:0] & data_out24[15:0] & data_out25[15:0] 
& data_out26[15:0] & data_out27[15:0] & data_out28[15:0] & data_out29[15:0] & data_out30[15:0] & data_out31[15:0]& data_out32[15:0];
// Daisy chain link
wire dc1,dc2,dc3,dc4,dc5,dc6,dc7,dc8,dc9, dc10,dc11,dc12,dc13,dc14,dc15,dc16,dc17,dc18,dc19,dc20,dc21,dc22,dc23,dc24,dc25,dc26,dc27,dc28,dc29,dc30,dc31;
//
// Neurons body		
neuron n1(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dci), .dco(dc1), .id(id1), .unclearn(unclearn1), .data_out(data_out1), .ready(ready1));
//
neuron n2(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc1), .dco(dc2), .id(id2), .unclearn(unclearn2), .data_out(data_out2), .ready(ready2));
//	 
neuron n3(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc2), .dco(dc3), .id(id3), .unclearn(unclearn3), .data_out(data_out3), .ready(ready3));
//	 
neuron n4(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc3), .dco(dc4), .id(id4), .unclearn(unclearn4), .data_out(data_out4), .ready(ready4));	
//
neuron n5(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc4), .dco(dc5), .id(id5), .unclearn(unclearn5), .data_out(data_out5), .ready(ready5));
//	 
neuron n6(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc5), .dco(dc6), .id(id6), .unclearn(unclearn6), .data_out(data_out6), .ready(ready6));
//	 
neuron n7(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc6), .dco(dc7), .id(id7), .unclearn(unclearn7), .data_out(data_out7), .ready(ready7));
//	 
neuron n8(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc7), .dco(dc8), .id(id8), .unclearn(unclearn8), .data_out(data_out8), .ready(ready8));
//	
neuron n9(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc8), .dco(dc9), .id(id9), .unclearn(unclearn9), .data_out(data_out9), .ready(ready9));
//
neuron n10(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc9), .dco(dc10), .id(id10), .unclearn(unclearn10), .data_out(data_out10), .ready(ready10));
//
neuron n11(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc10), .dco(dc11), .id(id11), .unclearn(unclearn11), .data_out(data_out11), .ready(ready11));
//	 
neuron n12(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc11), .dco(dc12), .id(id12), .unclearn(unclearn12), .data_out(data_out12), .ready(ready12));	
//	 
neuron n13(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc12), .dco(dc13), .id(id13), .unclearn(unclearn13), .data_out(data_out13), .ready(ready13));
//	
neuron n14(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc13), .dco(dc14), .id(id14), .unclearn(unclearn14), .data_out(data_out14), .ready(ready14));
//
neuron n15(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc14), .dco(dc15), .id(id15), .unclearn(unclearn15), .data_out(data_out15), .ready(ready15));
//    
neuron n16(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc15), .dco(dc16), .id(id16), .unclearn(unclearn16), .data_out(data_out16), .ready(ready16));	 
//	
neuron n17(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc16), .dco(dc17), .id(id17), .unclearn(unclearn17), .data_out(data_out17), .ready(ready17));
//
neuron n18(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc17), .dco(dc18), .id(id18), .unclearn(unclearn18), .data_out(data_out18), .ready(ready18));
//	 
neuron n19(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc18), .dco(dc19), .id(id19), .unclearn(unclearn19), .data_out(data_out19), .ready(ready19));
//	 
neuron n20(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc19), .dco(dc20), .id(id20), .unclearn(unclearn20), .data_out(data_out20), .ready(ready20));	
//
neuron n21(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc20), .dco(dc21), .id(id21), .unclearn(unclearn21), .data_out(data_out21), .ready(ready21));
//	 
neuron n22(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc21), .dco(dc22), .id(id22), .unclearn(unclearn22), .data_out(data_out22), .ready(ready22));
//	 
neuron n23(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc22), .dco(dc23), .id(id23), .unclearn(unclearn23), .data_out(data_out23), .ready(ready23));
//	 
neuron n24(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc23), .dco(dc24), .id(id24), .unclearn(unclearn24), .data_out(data_out24), .ready(ready24));
//	
neuron n25(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc24), .dco(dc25), .id(id25), .unclearn(unclearn25), .data_out(data_out25), .ready(ready25));
//
neuron n26(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc25), .dco(dc26), .id(id26), .unclearn(unclearn26), .data_out(data_out26), .ready(ready26));
//
neuron n27(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc26), .dco(dc27), .id(id27), .unclearn(unclearn27), .data_out(data_out27), .ready(ready27));
//	 
neuron n28(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc27), .dco(dc28), .id(id28), .unclearn(unclearn28), .data_out(data_out28), .ready(ready28));	
//	 
neuron n29(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc28), .dco(dc29), .id(id29), .unclearn(unclearn29), .data_out(data_out29), .ready(ready29));
//	
neuron n30(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc29), .dco(dc30), .id(id30), .unclearn(unclearn30), .data_out(data_out30), .ready(ready30));
//
neuron n31(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc30), .dco(dc31), .id(id31), .unclearn(unclearn31), .data_out(data_out31), .ready(ready31));
//    
neuron n32(.clk(clk),.reset_l(reset_l),.ds(ds), .read(read), .register(register), .data_in(data_in), .SR(SR), .KNN(KNN), 
    .oktolearn_in(oktolearn_in), .dci(dc31), .dco(dco), .id(id32), .unclearn(unclearn32), .data_out(data_out32), .ready(ready32));	 
//
endmodule
