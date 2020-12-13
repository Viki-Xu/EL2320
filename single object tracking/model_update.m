function [q_r, q_ms] = model_update(q_r, min_p, frame, q_ms)

Red = frame(:,:,1);
Green = frame(:,:,2);
Blue = frame(:,:,3);

W = 20; % estimated pixel width of tracked object
H = 75; % estimated pixel height of tracked object

% update the mean state histogram
range_x = round(min_p(1) - W/2):round(min_p(1) + W/2);
range_y = round(min_p(2) - H/2):round(min_p(2) + H/2);
    
try
    pR = imhist(Red(range_y, range_x), 8); % histograms of the particle
    pG = imhist(Green(range_y, range_x), 8);
    pB = imhist(Blue(range_y, range_x), 8);
    p = [pR; pG; pB]'; % measured histogram
    p = p/sum(p);% ensure that q_r is normalized
    q_ms = (p + q_ms)/2;
catch
    q_ms = q_ms;
end 

rho = sum(sqrt(q_ms.*q_r)); % calculate the probability of mean state
d = sqrt(1 - rho);

threshold = 0.1;
alpha = 0.05;

if d < threshold % make sure the object is not lost
    q_r = (1 - alpha) * q_r + alpha * q_ms;
end

end