% This function performs the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           z(t)                2Xn
% Outputs: 
%           c(t)                1Xn
%           outlier             1Xn
%           nu_bar(t)           2nX1
%           H_bar(t)            2nX3
function [c, outlier, nu_bar, H_bar] = batch_associate(mu_bar, sigma_bar, z)
        
        % YOUR IMPLEMENTATION %
        N = length(z(1,:));
        c = zeros(1,N);        % 1XN
        outlier = zeros(1,N);  % 1XN
        nu_bar = zeros(2*N,1); % 2NX1
        H_bar = zeros(2*N,3);  % 2NX3
        for j = 1:N 
           [c_j, outlier_j, nu, ~, H] = associate(mu_bar, sigma_bar, z(:,j));
           c(j) = c_j;
           outlier(j) = outlier_j;
           nu_bar(2*j-1:2*j, 1) = nu(:,c_j);
           H_bar(2*j-1:2*j, :) = H(:,:, c_j);
        end

end