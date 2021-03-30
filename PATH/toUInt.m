function out = toUInt(bS)

nbS = length(bS)/8; 
out = zeros(1,nbS);
for iN = 1 : 1 : nbS 
    cV = bS( (iN-1)*8 + (1:8));
    out(iN) = 2.^(0:1:7) * cV';
end

end



