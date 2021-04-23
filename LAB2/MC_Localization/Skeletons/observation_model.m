% This function is the implementation of the measurement model.
% The bearing should be in the interval [-pi,pi)
% Inputs:
%           S(t)                           4XM
%           j                              1X1
% Outputs:  
%           h                              2XM
function z_j = observation_model(S, j)

    global map % map including the coordinates of all landmarks | shape 2Xn for n landmarks
    global M % number of particles

    % YOUR IMPLEMENTATION
    h = zeros(2,M);
    Map = ones(2,M);
    Map = [map(1,j), map(2,j)]' .* Map;
    h = [sqrt((Map(1,:) - S(1,:)).^2 + (Map(2,:) - S(2,:)).^2); atan2( (Map(2,:) - S(2,:)),(Map(1,:) - S(1,:)) ) - S(3,:)];
    h(2,:) = mod(h(2,:) + pi, 2*pi) - pi;
    z_j = h;
end