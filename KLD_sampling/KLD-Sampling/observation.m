function [d, min_ind, d_min] = observation(q_r, S_bar, frame, n)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Red = frame(:,:,1);
Green = frame(:,:,2);
Blue = frame(:,:,3);

M = size(S_bar, 2);

d = zeros(1, M);
for i = 1:M % for each particle
    % calculate histogram window range
    range_x = round(S_bar(1,i) - S_bar(3,i)/2):round(S_bar(1,i) + S_bar(3,i)/2);
    range_y = round(S_bar(2,i) - S_bar(4,i)/2):round(S_bar(2,i) + S_bar(4,i)/2);
    
    try
        % calculate histogram of the particle
        
        [pR, ~] = histcounts(Red(range_y, range_x), linspace(0, 255, n+1));
        [pG, ~] = histcounts(Green(range_y, range_x), linspace(0, 255, n+1));
        [pB, ~] = histcounts(Blue(range_y, range_x), linspace(0, 255, n+1));
        
        p = [pR, pG, pB]'; % measured histogram
        p = p/sum(p);
        
        rho = sum(sqrt(p.*q_r));
        
        d(i) = sqrt(1 - rho);
    catch
        d(i) = 1;
    end
    
end


[d_min, min_ind] = min(d);

end

