function c_bin = encode_cc(m,cc)
    m2 = [m zeros(1,cc.k.*cc.nu+2)];
    [c,c_bin]=encodeCC(m2,cc.k,cc.n, cc.StateTable);
end


function [c,c_bin,PathThroughTrellis]=encodeCC(m,k,n, StateTable)

% [c,c_bin,PathThroughTrellis]=CVencode(m,k,n,StateTable)
% or 
% [c,c_bin]=CVencode(m,k,n,StateTable);
%
% c : encoded bits (decimal format)
% c_bin: encoded bits (binary format)
% m: imput binary sequence to be encoded
% k: No of input bits to encoder
% n: No of output bits from decoder
% StateTable: Encoder State Table (decimal format)
% note: may need further zero padding to end in zero state

% Apply zero padding is necessary
%  serial 2 parrallel
m1=reshape(m, k,length(m)./k)';
% convert to decimal
[NoOfSteps,B]=size(m1);
State=0;
c=zeros(1,NoOfSteps);
c_bin=[];
PathThroughTrellis=[0];
for i=1:NoOfSteps,
    m2(i)=bin2deci(m1(i,:));
    I=find(StateTable(:,1)==m2(i) & StateTable(:,2)==State);
    State=StateTable(I(1),3);
    c(i)=StateTable(I(1),4);
    c_bin=[c_bin deci2bin(c(i),n)];
    PathThroughTrellis=[PathThroughTrellis State];
end

if nargout==2,
    PathThroughTrellis=[];
end
end