% This function initializes the particles.
% Inputs:

%           M                 1X1
%           w                 1x1
%           h                 1x1
% Outputs:   
%           S                 3XM
function S = init(M,w,h,W,H)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pos = [round(w*rand(1, M)); round(h*rand(1, M))];
widths = round(W*ones(1, M));
heights = round(H*ones(1, M));
weights = 1/M*ones(1,M);

S = [pos; widths; heights; weights];
end

