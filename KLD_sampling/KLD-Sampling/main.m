clear
close all
clc

% video = 'boy-walking.mp4';
% video = 'ETH-Sunnyday-raw.webm';
% video = 'v1.mp4';

v = VideoReader('video_out.mp4');

M = 10000; % number of particles
nc = 16; % number of color histogram bins
ns = 100; % number of spatial bins (for KLD)
M_min = 600; % minimum number of particles (for KLD)
sigma = [15 15 16 13];
R = diag(sigma); % model noise
Q = 0.1; % measurement noise
v_thresh = 0.36; % object similarity threshold
u_thresh = 0.12; % model update threshold
alpha = 0.14; % means state contribution weight
vis = 2; % specify level of visualization: 0=no plot, 1=image, 2=image+particles
KLD = 1; % 1=KLD enabled, 0=KLD disabled
est_show = 0; % 0 = mean state, 1 = best match
eps = 0.3; % KLD parameter
delta = 0.99; % KLD parameter (technically 1-delta) 

gt = load('blue_car_london.txt'); 
gt = gt(:,3:6)';
gt(1:2,:) = gt(1:2,:) + gt(3:4,:)/2; % move origin from top left to center

[X, num] = particle_filter(v, M, M_min, nc, ns, R, Q, v_thresh, u_thresh, alpha, eps, delta, vis, KLD, gt, est_show);

% pose and window error
e = gt - X(:,1:length(gt));

% get error statistics
mex = mean(e(1,:));
mey = mean(e(2,:));
mew = mean(e(3,:));
meh = mean(e(4,:));

maex = mean(abs(e(1,:)));
maey = mean(abs(e(2,:)));
maew = mean(abs(e(3,:)));
maeh = mean(abs(e(4,:)));


% plot errors
figure('Name', 'Evolution State Estimation Errors');
clf;
subplot(4,1,1);
plot(e(1,:));
ylabel('error\_x [m]');
title(sprintf('error on x, mean error = %.2fm, mean absolute err = %.2fm', mex, maex));
subplot(4,1,2);
plot(e(2,:));
ylabel('error\_y [m]');
title(sprintf('error on y, mean error = %.2fm, mean absolute err = %.2fm', mey, maey));
subplot(4,1,3);
plot(e(3,:));
ylabel('error\_y [m]');
title(sprintf('error on width, mean error = %.2fm, mean absolute err = %.2fm', mew, maew));
subplot(4,1,4);
plot(e(4,:));
ylabel('error\_y [m]');
title(sprintf('error on height, mean error = %.2fm, mean absolute err = %.2fm', meh, maeh));

figure('Name', 'Number of particles');
plot(num)