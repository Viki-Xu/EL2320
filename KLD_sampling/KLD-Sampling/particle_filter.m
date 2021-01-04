function [X, num, q_rc, prob] = particle_filter(v, M, M_min, nc, ns, R, Q, v_thresh, u_thresh, alpha, eps, delta, vis, KLD, gt, est_show)
%PARTICLE_FILTER This function tracks objects on a video stream using the
%particle filter

% Inputs:   
%           video, name of video stream:            1X1 string
%           M, number of particles:                 1X1
%           n, number of bins:                      1X1
%           R, model covariance matrix:             4X4
%           Q, measurement covariance matrix:       1X1
%           v_thresh, object similarity threshold:  1X1
%           u_thresh, model update threshold;       1X1
%           alpha, means state contribution weight: 1X1
%           vis, specify level of visualization:    1X1
%
% Outputs:
%           X, estimated target window:             4XNumFrames

if nargin < 14
    gt = [];
end
    
if isempty(gt)
    NF = v.NumFrame;
else
    NF = size(gt, 2);
end

X = zeros(4, v.NumFrame - 1); 
frame = readFrame(v);
% ----------- Select window for target histogram initialization -----------
imshow(frame);
disp('Select region to use as reference for tracking...')
rect = drawrectangle();
disp('Region selected, tracking...')
rect_pos = round(rect.Position); % [xmin, ymin, width, height];
object_frame = frame(rect_pos(2) + (0:rect_pos(4)), rect_pos(1) + ...
    +(0:rect_pos(3)), :);
% ------------------------- initialize particles -------------------------
W = rect.Position(3); % selected window width
H = rect.Position(4);
S = init(M, v.Width, v.Height, W, H); % initialize particle filter
% -------------------- Compute reference histogram q_r --------------------
Red = object_frame(:,:,1);
Green = object_frame(:,:,2);
Blue = object_frame(:,:,3);

[yRed, ~] = histcounts(Red(:), linspace(0, 255, nc+1));
[yGreen, ~] = histcounts(Green, linspace(0, 255, nc+1));
[yBlue, ~] = histcounts(Blue, linspace(0, 255, nc+1));

q_r = [yRed, yGreen, yBlue]';
q_r = q_r/sum(q_r); % reference histogram
q_ms = q_r; % initialize mean state histogram
% -------------------------------------------------------------------------
 % Read all the frames from the video, one frame at a time
i = 1; % current frame
% while hasFrame(v)
num(i) = M;
z = 2;
q_rc = zeros(6,48,1);
q_rc(1,:,:) = q_r;

while i < NF
    frame = readFrame(v);
    S_bar = predict(S, R); % prediction
    [d, ~, ~] = observation(q_r, S_bar, frame, nc); % observation
    S_bar = weight(S_bar, d, Q); % weighting
    [q_r, q_ms, E, dE] = model_update(q_r, frame, q_ms, S_bar, nc, u_thresh, alpha, est_show); % model update
    prob(i) = 1/(sqrt(2*pi)*Q)*exp(-dE.^2/(2*Q^2));
    if mod(i,60) == 0
        q_rc(z,:,:)=q_r;
        z = z+1;
    end
    if KLD
        [S_bar, num_i] = KLD_sample(S_bar, eps, delta, v.Width, v.Height, M_min, ns); % KLD-sampling
    else
        num_i = length(S_bar(5,:));
    end
    S = systematic_resample(S_bar); % resampling

    % plot particles
    if vis >= 2
        subplot(2, 1, 1)
        scatter(S(1, :), fliplr(S(2, :)), 3.5, 'filled', 'g');
        axis([0 v.Width 0 v.Height])
        set(gca,'Ydir','reverse')
        pbaspect([1, v.Height/v.Width, 1])
        pause(0.001)
        
        subplot(2, 1, 2)
    end
    
    % plot boxes, save estimate
    rect = [];
    c = {'blue'};
    if dE < v_thresh
        X(1:2,i) = E(1:2); % save estimated position
      
        if vis >= 1
            if isempty(gt)
                rect = [E(1:2)' - E(3:4)'/2, E(3), E(4)];
                c = {'red'};
            else
                rect = [gt(1:2,i)' - gt(3:4,i)'/2, gt(3,i), gt(4,i); E(1:2)' - E(3:4)'/2, E(3), E(4)];
                c = {'blue', 'red'};
            end
        end
    elseif vis >= 1
        if ~isempty(gt)
            rect = [gt(1:2,i)' - gt(3:4,i)'/2, gt(3,i), gt(4,i)];
        end
    end
    
    if vis >= 1
        RGB = insertShape(frame, 'Rectangle', rect, 'LineWidth', 3, 'Color', c);
        imshow(RGB)
    end
    
    i = i+1;
    num(i)=num_i;
    
end



end
