function [err] = crcDecode(sizeCRC,data)
% --- get the polynom values 
gx      = getCRCPoly(sizeCRC);
lenR    = length(data);    % length of the received codeword
lenGW   = length(gx);     % length of the generator

% --- Do the CRC convolution 
for i = 1 : 1 : lenR - lenGW + 1
    if data(1,i) == 1
        data(1,i:i+lenGW-1) = bitxor(data(1,i:i+lenGW-1),gx);
    end
end
% --- syndrome is now equal to the remainder of xor division
syndrome = data(1, lenR - lenGW + 2: lenR);
% --- From syndrom to CRC check 
err = ??? 
end
