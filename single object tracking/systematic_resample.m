% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
cdf = cumsum(S_bar(3,:));
M = size(S_bar, 2);
S = zeros(size(S_bar));
r_0 = rand / M;
for m = 1 : M
    i = find(cdf >= r_0,1,'first');
    S(1:2,m) = S_bar(1:2,i);
    r_0 = r_0 + 1/M;
end
S(3,:) = 1/M*ones(size(S_bar(3,:)));
end