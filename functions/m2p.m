function [p1, p2, p3, p4] = m2p(dist, m1, m2, m3, m4)

% m2p converts central moments of a distirbution to its parameter values
% Input - 
%   DIST - name of distribution, e.g., 'normal', 'gamma', etc.
%   M# - #-th central moment
% Output
%   Variable length parameter values depending on distribution, e.g.,
%   For gamma distribution, alpha, beta
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if nargin <= 4
    m4 = 0;
end
if nargin <= 3
    m3 = 0;
end
if nargin <= 2
    m2 = 1;
end
if nargin <= 1
    m1 = 0;
end
if nargin <= 0
    dist = 'normal';
end

switch dist
    case 'gamma'
        beta = m1 / m2;
        alpha = m1 * beta;
        if alpha == 0 || beta == 0
            fprintf('bad moments\n')
        end
        p1 = alpha; p2 = beta; p3 = nan; p4 = nan;
end