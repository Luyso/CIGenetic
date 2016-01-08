function stringSet(property,value,set)
%stringSet one of a set of strings

%   Copyright 2007-2014 The MathWorks, Inc.

for i = 1:length(set)
    if strcmpi(value,set{i})
        return;
    end
end
prop = sprintf('%s, %s, %s, %s, %s',set{:});
error(message('globaloptim:stringSet:notCorrectChoice',property,prop));
