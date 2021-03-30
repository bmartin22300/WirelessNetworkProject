function out = toVal(bS)
  out = sum(2.^(length(bS)-1:-1:0) .* bS);
end