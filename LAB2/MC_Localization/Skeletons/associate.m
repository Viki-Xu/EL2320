% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement
% Outputs: 
%           outlier                  1Xn
%           Psi(t)                   1XnXM
function [outlier, Psi, c] = associate(S_bar, z, association_ground_truth)
    if nargin < 3
        association_ground_truth = [];
    end

    global DATA_ASSOCIATION % wheter to perform data association or use ground truth
    global lambda_psi % threshold on average likelihood for outlier detection
    global Q % covariance matrix of the measurement model
    global M % number of particles
    global N % number of landmarks
    global landmark_ids % unique landmark IDs
    
    % YOUR IMPLEMENTATION
    
    [~, n] = size(z); % number of observations
    
    %z_hat = zeros(2, M, N);
    %nu = zeros(2, M, N);
    phi = zeros(1, M, N);
    Psi = zeros(1, n, M);
    outlier = zeros(1,n);
    
    Qd = det(Q);
    %Qi = inv(Q);
    
    for i = 1:n % for each observation
        for k = 1:N % for each landmark
            z_hat = observation_model(S_bar, k); % for all particles
            size(z_hat);
            nu = z(:,i) - z_hat; % for all particles  |2XM
            nu(2,:)=mod(nu(2,:)+pi,2*pi)-pi;
            phi(:,:,k) = 1/(2*pi*sqrt(Qd)) * exp(-0.5 * diag(nu'/ Q * nu));
        end
        [~, c] = max(phi, [], 3); % maximizes over landmarks for observ. i
         
%         for m = 1:M % for each particle
%             Psi(1, i, m) = phi(1,m,c(m));
%         end
        m = 1:1000;
        Psi(1, i, m) = diag(squeeze(phi(1,m,c(m))));
        

        L = 1/M*sum(Psi(1, i, :));
        if L <= lambda_psi
            outlier(i) = true;
        else
            outlier(i) = false;
        end
    end
end