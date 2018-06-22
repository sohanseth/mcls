function h = mysubplot(ROW, COL, LOC, varargin)
% MYSUBPLOT creates a subplot and returns the handle
%   MYSUBPLOT(ROW, COL, LOC) creates a subplot a location LOC in a ROWxLOC matrix
%   where LOC is encoded as [[1 2 ... COL]; [COL+1, ...]; ...
%   This function uses the following optional arguments:
%       top: top margin between [0,1] (default 0)
%       bottom: bottom margin between [0,1] (default 0)
%       left: left margin between [0,1] (default 0)
%       right: right margin between [0,1] (default 0)
%       row: gap between two rows between [0,1] (default 0)
%       column: gap between two columns between [0,1] (default 0)
%
%   Example:
%       mysubplot(3, 5, 6, 'top', 0.05, 'bottom', 0.05, 'left', 0.05, 'right', 0.05, 'row', 0.01, 'column', 0.01);
%       
% Author: Sohan Seth, sseth@inf.ed.ac.uk

varList = {'left', 'bottom', 'right', 'top', 'row', 'column'};
varDefault = {0, 0, 0, 0, 0, 0};
margins = parseVarArg(varList, varDefault, varargin);

width = (1 - margins.left - margins.right - (COL - 1) * margins.column) / COL;
height = (1 - margins.bottom - margins.top - (ROW - 1) * margins.row) / ROW;

countRow = ROW + 1 - ceil(LOC/COL);
countCol = LOC - (ceil(LOC/COL) - 1) *  COL;

h = subplot('position', ...
    [margins.left + (width + margins.column) * (countCol - 1), ...
    margins.bottom + (height + margins.row) * (countRow - 1), ...
    width, height]);