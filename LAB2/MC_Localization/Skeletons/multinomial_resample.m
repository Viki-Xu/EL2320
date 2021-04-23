% This function performs multinomial re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)
    M = size(S_bar(1:3, :), 2);
    
    % YOUR IMPLEMENTATION
    S = zeros(4,M);
    weight=1/M;
    %CDF(1) = S_bar(4,1);
    
    CDF = cumsum(S_bar(4, :));
    rng(1);
    for m=1:M
        r_m = rand;
        argmin = find(CDF>=r_m,1);
        S(:,m) = [S_bar(1:3,argmin); weight];
    end
end
