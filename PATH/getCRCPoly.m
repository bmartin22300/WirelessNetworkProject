function gx = getCRCPoly(sizeCRC)
gx = zeros(1,1+sizeCRC);
gx(1) = 1;
switch sizeCRC
    case 8
        gx(1+[1 2 8]) = 1;
    case 16
        gx(??) = ?;
    case 24
        gx(?? ) = ?;
    case 32
        gx( ??) =  ??;
    otherwise
        error('imr:crc','unknwon CRC size');
end
end
