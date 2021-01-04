% This function updates the bins with support
%           S_bar(t,i)          5X1
%           bin                 32X32
%           x_grid              33X1
%           y_grid              33X1
%           k                   1X1
% Outputs: 
%           bin                 32X32
%           k                   1X1
function [k, H, fall] = bins(S_bar, H, x_grid, y_grid, k)
fall = false;
x_ind = find((S_bar(1)<x_grid),1) - 1;
y_ind = find((S_bar(2)<y_grid),1) - 1;
if H(x_ind,y_ind)==0
    fall = true; % falls into empty bin
    H(x_ind,y_ind) = 1;
    k = k+1;
end

end