function [d, min_ind, d_min, min_p] = observation(q_r, S_bar, frame)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Red = frame(:,:,1);
Green = frame(:,:,2);
Blue = frame(:,:,3);

N = size(S_bar, 2);

w = 20; % estimated pixel width of tracked object
h = 75; % estimated pixel height of tracked object

H = 0.9*h + (1.1*h-0.9*h).*rand; % window height
W = 0.9*w + (1.1*w-0.9*w).*rand; % window width

% pR = zeros(8, N);
% pG = zeros(8, N);
% pB = zeros(8, N);
d = zeros(1, N);
for i = 1:N % for each particle
    range_x = round(S_bar(1,i) - W/2):round(S_bar(1,i) + W/2);
    range_y = round(S_bar(2,i) - H/2):round(S_bar(2,i) + H/2);
    
    try
        pR = imhist(Red(range_y, range_x), 8); % histograms of the particle
        pG = imhist(Green(range_y, range_x), 8);
        pB = imhist(Blue(range_y, range_x), 8);
      
        p = [pR; pG; pB]'; % measured histogram
        p = p/sum(p);
        
        % ensure that q_r is normalized
        
        rho = sum(sqrt(p.*q_r)); % size 1X1 for each particle, normalized to 1
        
        d(i) = sqrt(1 - rho);
    catch 
        d(i) = 1;
    end 
    
end

[d_min, min_ind] = max(d);
min_x = S_bar(1,min_ind);
min_y = S_bar(2,min_ind);
min_p = [min_x, min_y];

end

