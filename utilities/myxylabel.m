function myxylabel(x, y, t, varargin)
% MYXYLABEL sets the X-axis label, Y-axis label and title, and sets the fontsize to 8
%   MYXYLABEL(X, Y, T) sets the X-axis label to X, Y-axis label to Y, and
%   title to T. The title is set to normal font.
%
%   The function takes the following optional arguments 
%       fontsize: default 8
%       fontname: default is palatino
%       interpreter: default is tex
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

varList = {'fontsize', 'fontname', 'interpreter'};
varDefault = {8, 'palatino', 'tex'};
options = parseVarArg(varList, varDefault, varargin);

set(gca, 'fontsize', options.fontsize, 'fontname', options.fontname)
xlabel(x, 'fontsize', options.fontsize, 'fontname', options.fontname, 'interpreter', options.interpreter)
ylabel(y, 'fontsize', options.fontsize, 'fontname', options.fontname, 'interpreter', options.interpreter)
title(t, 'fontsize', options.fontsize, 'fontweight', 'normal', 'interpreter', options.interpreter)