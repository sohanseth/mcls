function options = parseVarArg(argumentList, argumentDefault, varargin)
% PARSEVARARG parses a (argument, value) pair list and put them in a structure
%
%   OPTIONS = PARSEVARARG(ARGUMENTLIST, ARGUMENTDEFAULT, PARSESTRING)
%   parses the cell array PARSESTRING given as {argument1, value1, argument2, 
%   value2, ...}, and returns a structure OPTIONS with fields argument1,
%   argument2, Etc with values value1, value2, etc. ARGUMENLIST contains
%   the list of arguments, and ARGUMENTDEFAULT contains their default values.
%   PARSESTRING can also be passed as a variable length input.
%
% Example:
%   argumentList = {'A', 'B', 'C'};
%   argumentDefault = {false, [], 'SS'};
%   parseString = {'A', true, 'B', [1 6 10]};
%   options = parseVarArg(argumentList, argumentDefault, parseString);
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

options = struct;
for count = 1:numel(argumentList)
    options = setfield(options, argumentList{count}, argumentDefault{count});
end

if numel(varargin) == 1
    varargin = varargin{1};
end

for count = 1:2:numel(varargin)
    ind = strcmpi(varargin{count}, argumentList);
    if sum(ind) == 0
        error(sprintf('unknown option %s', varargin{count}))
    end
    if any(ind)
        options.(argumentList{ind}) = varargin{count + 1};
    end   
end