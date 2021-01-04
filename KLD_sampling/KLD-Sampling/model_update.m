function [q_r, q_ms, E, d] = model_update(q_r, frame, q_ms, S_bar, n, u_thresh, alpha, est_show)

Red = frame(:,:,1);
Green = frame(:,:,2);
Blue = frame(:,:,3);
E = zeros(4,1);
if est_show == 0
    E(1:4) = sum(S_bar(5,:).*S_bar(1:4,:), 2); % mean state, use equation 1
    %[~,ind] = max(S_bar(5,:));
    %E(3:4) = S_bar(3:4,ind);
else
    [~,ind] = max(S_bar(5,:));
    E = S_bar(1:4,ind);
end


% update the mean state histogram
range_x = round(E(1) - E(3)/2):round(E(1) + E(3)/2);
range_y = round(E(2) - E(4)/2):round(E(2) + E(4)/2);
    
try
    [pR, ~] = histcounts(Red(range_y, range_x), linspace(0, 255, n+1));
    [pG, ~] = histcounts(Green(range_y, range_x), linspace(0, 255, n+1));
    [pB, ~] = histcounts(Blue(range_y, range_x), linspace(0, 255, n+1));

    q_ms = [pR, pG, pB]'; % measured histogram
    q_ms = q_ms/sum(q_ms);% ensure that q_ms is normalized
catch
    %q_ms = q_ms;
end 

rho = sum(sqrt(q_ms.*q_r)); % calculate the probability of mean state
d = sqrt(1 - rho)

% d proportional to pi_T (eq. 9)
if d < u_thresh % make sure the object is not lost
    disp('reference histogram updated')
    q_r = (1 - alpha) * q_r + alpha * q_ms;
end

end