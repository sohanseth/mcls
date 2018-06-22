function Y = myunique(X, onlyExclusive)
% MYUNIQUE returns the unique elements and their frequencies
%   Y = MYUNIQUE(X) takes a [nxd] matrix X as input and returns a [mx(d+1)]
%   matrix Y with m unique rows of X and their frequencies in the last column.
%   The unique entries are sorted in ascending order of their counts.
%
%   Y = MYUNIQUE(X, TRUE) returns only entries which do not repeat, i.e., for
%   which the frequency of occurence is 1. Y is now [mxd] dimensional.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

X = double(X);
if any(size(X) == 1)
    X = X(:);
end

if nargin == 1
    onlyExclusive = false;
end

[A, B, C] = unique(sortrows(X), 'rows');
Y = sortrows([A, [B(2:end); length(C)+1] - B(:)],2);

if onlyExclusive
    Y = Y(Y(:,2) == 1);
end

% 09.07.2015 - modified to add sortrows and 'rows' options to deal with matrices
% 06.10.2017 - fixed error