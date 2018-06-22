function H = mylegend(varargin)
% MYLEGEND creates legends
%   MYLEGEND(...) creates legends for a figure, sets the fontsize of the
%   text to 8, fontname to palatino and sets the color and edgecolor to transparent.
%
%   MYLEGEND(..., 'compact') does the same, and additionally squeeze the
%   icons and the texts of the lengend to make it more compact. Not
%   recommended for linestyle '--'.
%
%   H = MYLEGEND(...) returns the legend handle
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

FONTSIZE = 8;

makecompact = any(strcmpi(varargin, 'compact'));
if makecompact
    varargin(strcmpi(varargin, 'compact')) = [];
end

[H, I] = legend(varargin{:});

noOfItems = length(I)/3;
for count = 2*((1:noOfItems) - 1) + 1 + noOfItems
    shiftBy = 0.5 * (I(count).XData(2) - I(count).XData(1));
    I(count).XData(1) = I(count).XData(1) + shiftBy;
    I(count + 1).XData(1) = I(count + 1).XData(1) + shiftBy / 2;
end

if strcmpi(H.Location, 'southwest')
    H.Position = H.Position - [0.05 0 0 0];
end
set(H, 'color', 'none', 'edgecolor', 'none', 'fontsize', FONTSIZE, 'fontname', 'palatino')

% TODO: texts et at. should be shifted differently for southeast and southwest 