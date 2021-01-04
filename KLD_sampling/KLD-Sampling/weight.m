% This function calcultes the weights for each particle based on the
% observation likelihood
%           S_bar(t)            3XM
%           d                   1XM
%           Q                   1X1
% Outputs: 
%           S_bar(t)            3XM
function S_bar = weight(S_bar, d, Q)
    weight = 1/(sqrt(2*pi)*Q)*exp(-d.^2/(2*Q^2));
    S_bar(5,:) = weight/sum(weight); % normalize
end
