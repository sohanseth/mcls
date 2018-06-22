function h = myfigure(shape)
% MYIGURE creates a figure window and returns the handle. The figure in placed at
% the bottom left corner of the screen.
%
% 	MYFIGURE creates a figure window of width 3.5 inches and height 3.5 inches.
%
% 	MYFIGURE(SHAPE) creates a figure window where shape contains the width
% 	and height in inch. SHAPE can also be chosen from the following
%	predefined options:
%		'small' (width = 3.5 inches, height = 3.5 inches)
% 		'flat' (width = 7 inches, height = 3.5 inches)
% 		'tall' (width = 3.5 inches, height = 7 inches)
% 		'large' (width = 7 inches, height = 7 inches)
%
% Example:
% 	h = myfigure();
% 	h = myfigure('small');
%	h = myfigure([3.5 3.5]);
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

if nargin == 0
    shape = 'small';
end

VISIBLE = 'on';
if ~ischar(shape)
    WIDTH = shape(1); HEIGHT = shape(2);
else
    switch shape
        case 'small'
            WIDTH = 3.5; HEIGHT = 3.5;
        case 'tall'
            WIDTH = 3.5; HEIGHT = 7;
        case 'flat'
            WIDTH = 7; HEIGHT = 3.5;
        case 'large'
            WIDTH = 7; HEIGHT = 7;
        otherwise
            error('unknown option')
    end
end

h = figure('units', 'inch', 'color', [1 1 1], ...
    'papertype', 'a4', 'paperunits', 'inch', ...
    'paperposition', [0 0 WIDTH HEIGHT], ...
    'position', [0 0 WIDTH HEIGHT], 'visible', VISIBLE);