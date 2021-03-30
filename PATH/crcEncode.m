function frame = crcEncode(crcSize,data)
poly = getCRCPoly(crcSize);
[M N]=size(poly);
mseg=[data zeros(1,N-1)];
[q r]=deconv(mseg,poly);
r=abs(r);
for i=1:length(r)
    a=r(i);
    if ( mod(a,2)== 0 )
        r(i)=0;
    else
        r(i)=1;
    end
end
crc=r(length(data)+1:end);
frame = bitor(mseg,r);

end