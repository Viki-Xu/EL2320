% This function performs the prediction step.
% Inputs:
%           S(t-1)            4XN
%           v                 1X1
%           omega             1X1
% Outputs:   
%           S_bar(t)          4XN
function [S_bar] = predict(S, v, omega, delta_t)

    % Comment out any S_bar(3, :) = mod(S_bar(3,:)+pi,2*pi) - pi before
    % running the test script as it will cause a conflict with the test
    % function. If your function passes, uncomment again for the
    % simulation.

    global R % covariance matrix of motion model | shape 3X3
    global M % number of particles
    
    % YOUR IMPLEMENTATION
    N = length(S(1,:));
    u_bar = zeros(3,N);
    sigma1 = R(1,1);
    sigma2 = R(2,2);
    sigma3 = R(3,3);
    r1 = normrnd(0,sigma1,[1,N]);
    r2 = normrnd(0,sigma2,[1,N]);
    r3 = normrnd(0,sigma3,[1,N]);
    u_bar(1,:) = v * cos(S(3,:)) * delta_t + r1;
    u_bar(2,:) = v * sin(S(3,:)) * delta_t + r2;
    u_bar(3,:) = omega * delta_t + r3;
    S_bar(1:3,:) = S(1:3,:) + u_bar;
    S_bar(4,:) = S(4,:);
   % S_bar(3, :) = mod(S_bar(3,:)+pi,2*pi) - pi;
end