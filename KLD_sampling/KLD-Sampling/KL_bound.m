% this function is to calculate K-L bound
% Inputs:   
%           k:       1X1
%           epsilon: 1X1
%           delta:   1X1
% Outputs:
%           Mx:       1X1
function Mx = KL_bound(k, eps, delta)
Mx = (k - 1) / (2 * eps) * (1 - 2 / (9*(k-1)) + sqrt( 2 / (9*(k-1))) * norminv(delta))^3;
end