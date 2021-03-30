function check_Hamming748()
addpath('PATH');
% Apply unit test for BPSK demapping 
% Create the random sequence 
N = 256;
b = (randn(1,N)>0);
% Encode the data 
bC = hammingEncode(b);
% -------------
% Test 1 : No error
% -------------
% Call the user method 
bD = hamming748_decode(bC);
if length(bD) ~= N
    disp('FAILED Test 0 for hamming decoder  [decoded sequence has not the required length]');
end
% --- Check 
% Get BER 
e = sum(xor(b,bD));
% Print the result 
if e == 0
   disp('Test 1 for hamming decoder is Correct [Error recovered when no error]');
else 
    disp('FAIL test 1 for hamming decoder is Correct [Error recovered when no error');
end
% -------------
% Test `1 : Add an error 
% -------------
% Add an error
bC(2) = bC(2) < 0.5;
% Call the user method 
bD = hamming748_decode(bC);
% --- Check 
% Get BER 
e = sum(xor(b,bD));
% Print the result 
if e == 0
   disp('Test 2 for hamming decoder is Correct [Error corrected]');
else 
    disp('FAIL test 2 for hamming decoder is Correct [Error corrected');
end
% -------------
% Test 3 : Add two errors 
% -------------
% Add an error
bC(3) = bC(3) < 0.5;
% Call the user method 
bD = hamming748_decode(bC);
% --- Check 
% Get BER 
e = sum(xor(b,bD));
% Print the result 
if e ~= 0
   disp('Test 3 for hamming decoder is Correct [2 Errors cannot be corrected]');
else 
    disp('FAIL test 3 for hamming decoder is Correct [2 Errors cannot be corrected]');
end
end