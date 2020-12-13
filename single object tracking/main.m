close all

v = VideoReader('boy-walking.mp4');

% Read all the frames from the video, one frame at a time

S = init(300, v.Width, v.Height); % initialize particle filter
R = [3, 0; 0 3];
Q = 1;

frame_init = imread('boy_init.png');

Red = frame_init(:,:,1);
Green = frame_init(:,:,2);
Blue = frame_init(:,:,3);

[yRed, x] = imhist(Red, 8);
[yGreen, x] = imhist(Green, 8);
[yBlue, x] = imhist(Blue, 8);

q_r = [yRed; yGreen; yBlue]';
q_r = q_r/sum(q_r);
q_ms = q_r; % the mean state histogram

while hasFrame(v)
    frame = readFrame(v);
    
    S_bar = predict(S, R); % prediction
    
    [d, min_ind, d_min, min_p] = observation(q_r, S_bar, frame); % observation
    
    S_bar = weight(S_bar, d, Q); % weighting
    
    [q_r, q_ms] = model_update(q_r, min_p, frame, q_ms); %model update
    
    S = systematic_resample(S_bar);
    subplot(2, 1, 1)
    particle_plot = scatter(S(1, :), S(2, :), 3, 'filled', 'g');
    axis([0 v.Width 0 v.Height])
    pause(0.01)
 
    subplot(2, 1, 2)
    if d_min < 0.9
        RGB = insertShape(frame, 'Rectangle', [mean(S_bar(1:2,:),2)', 20, 75], 'LineWidth', 3, 'Color', 'red');
        imshow(RGB)
    else
        imshow(frame)
    end
    
end










% Red = image(:,:,1);
% Green = image(:,:,2);
% Blue = image(:,:,3);
% 
% [yRed, x] = imhist(Red, 8);
% [yGreen, x] = imhist(Green, 8);
% [yBlue, x] = imhist(Blue, 8);
% 
% plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');
% figure
% subplot(3,1,1)
% bar(x, yRed, 'Red')
% subplot(3,1,2)
% bar(x, yGreen, 'Green')
% subplot(3,1,3)
% bar(x, yBlue, 'Blue')
