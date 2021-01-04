% This function performs the prediction step.
% Inputs:

%           S(t-1)            5XM
%           R                 4X4
% Outputs:   
%           S_bar(t)          5XM
function [S_bar] = predict(S, R)
    S_bar = S;
    sigma1 = R(1,1);
    sigma2 = R(2,2);
    sigma3 = R(3,3);
    sigma4 = R(4,4);
    M = size(S, 2);
    
    % use abs in case the window size is negative
    S_bar(1:4,:) = abs(S(1:4,:) + [normrnd(0,sigma1,[1,M]); normrnd(0,sigma2,[1,M]); normrnd(0,sigma3,[1,M]); normrnd(0,sigma4,[1,M])]);
end