% This function performs multinomial re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)
M = size(S_bar, 2);
S = zeros(3,M);
cdf = cumsum(S_bar(3, :));
for m = 1 : M
    r_m = rand;
    i = find(cdf >= r_m,1);
    S(1:2,m) = S_bar(1:2,i);
end
S(3,:) = 1/M;
end
