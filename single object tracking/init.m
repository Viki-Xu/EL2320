function S = init(M,w,h)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
weights = 1/M*ones(1,M);
pos = [round(w*rand(1, M)); round(h*rand(1, M))];

S = [pos; weights];
end

