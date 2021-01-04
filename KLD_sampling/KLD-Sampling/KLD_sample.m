function [S,M] = KLD_sample(S_bar, eps, delta, Width, Height, M_min, ns)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

M = 0;
Mx = 0;
k = 0;
x_grid = linspace(0, Width, ns + 1);
y_grid = linspace(0, Height, ns + 1);
H = zeros(ns,ns); % empty histogram

N = size(S_bar, 2);

for i = 1 : N
    % update number of bins with support and number of particles
    [k, H, fall] = bins(S_bar(:,i), H, x_grid, y_grid, k);
    
    if fall % if S(i) falls into empty bin
    
        % check KL bound
        if k > 1
            Mx = KL_bound(k, eps, delta);
        end
    end
    M = M + 1;
    
    if M >= Mx && M >= M_min
        break;
    end
    
end

S = S_bar(:, 1:i);

S(5,:) = S(5,:)/sum(S(5,:)); % normalize weights

end