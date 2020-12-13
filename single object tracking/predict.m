% This function performs the prediction step.
% Inputs:

%           S(t-1)            3XN
%           R                 2X2
% Outputs:   
%           S_bar(t)          3XN
function [S_bar] = predict(S, R)
    S_bar = S;
    sigma1 = R(1,1);
    sigma2 = R(2,2);
    N = size(S, 2);
    
    S_bar(1:2,:) = S(1:2,:) + [normrnd(0,sigma1,[1,N]); normrnd(0,sigma2,[1,N])];
end