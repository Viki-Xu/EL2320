% This function performs the maximum likelihood association and outlier detection given a single measurement.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           z_i(t)              2X1
% Outputs: 
%           c(t)                1X1
%           outlier             1X1
%           nu^i(t)             2XN
%           S^i(t)              2X2XN
%           H^i(t)              2X3XN
function [c, outlier, nu, S, H] = associate(mu_bar, sigma_bar, z_i)

    % Import global variables
    global Q % measurement covariance matrix | 2X2
    global lambda_m % outlier detection threshold on mahalanobis distance | 1X1
    global map % map | 2Xn
    
    phi = zeros(length(map(1,:)), 1);   % |nX1
    nu = zeros(2, length(map(1,:)));    % |2Xn
    S = zeros(2, 2, length(map(1,:))); % |2X2Xn
    H = zeros(2, 3, length(map(1,:))); % |2X3Xn
    D = zeros(1, length(map(1,:)));    % |1Xn
    for j = 1:length(map(1,:))
        z_hat = observation_model(mu_bar, j);
        H(:, :, j) = jacobian_observation_model(mu_bar, j, z_hat);
        S(:, :, j) = H(:, :, j) * sigma_bar * H(:, :, j)' + Q;
        nu(:, j) = z_i - z_hat;
        nu(2, j) = mod(nu(2, j) + pi, 2*pi) - pi;
        D(j) = nu(:, j)' * inv(S(:, :, j)) * nu(:, j);
        phi(j) = 1 / sqrt(det(2 * pi * S(:, :, j))) * exp(-0.5 * nu(:, j)' * inv(S(:, :, j)) * nu(:, j));
    end
    
    [a, c] = max(phi);
    if D(c) >= lambda_m
        outlier = true;
    else
        outlier = false;
    end
    % YOUR IMPLEMENTATION % 

end