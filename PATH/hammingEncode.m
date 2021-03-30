function y = hammingEncode(x)	
	% --- Matrix encoder 
	A = [ 1 1 1;1 1 0;1 0 1;0 1 1];
	G = [eye(4) A];
	% --- Init output  
	nL	= floor(length(x) /4);
	y	= zeros(1,nL*8);
	% --- 
	for iN = 1 : 1 : nL 
		% --- Get 4 bits
		subM	  = x((iN-1)*4 + (1:4));
		% --- Apply encoder 
		out =  mod((subM * G),2);
		% --- Additionnal parity bit 
		parity	  = mod(sum(out),2);
		y((iN-1)*8 + (1:7)) = out;
		% --- Store parity bit
		y(iN*8)	  = parity;
	end
end