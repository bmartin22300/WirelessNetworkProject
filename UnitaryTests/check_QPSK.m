function check_QPSK()
addpath('PATH');
% Apply unit test for BPSK demapping 
% Create the random sequence 
N = 256;
b = (randn(1,N)>0);
% Add some noise to be sure that we are resistant 
y   = bitMapping(b,2);
% y   = y + rand(1,length(y))*1/5;
% Call the function done by student 
bE  = QPSK_demod(y);
% Get BER 
e = sum(xor(bE,b));
% Print the result 
if e == 0
   disp('Test for QPSK mapping is Correct');
else 
    disp('FAIL test for QPSK demapping');
end
end