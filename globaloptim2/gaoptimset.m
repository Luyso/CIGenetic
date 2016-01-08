function options = gaoptimset(varargin)
%GAOPTIMSET Create/alter GA OPTIONS structure.
%   GAOPTIMSET returns a listing of the fields in the options structure as
%   well as valid parameters and the default parameter.
%   
%   OPTIONS = GAOPTIMSET('PARAM',VALUE) creates a structure with the
%   default parameters used for all PARAM not specified, and will use the
%   passed argument VALUE for the specified PARAM.
%
%   OPTIONS = GAOPTIMSET('PARAM1',VALUE1,'PARAM2',VALUE2,....) will create a
%   structure with the default parameters used for all fields not specified.
%   Those FIELDS specified will be assigned the corresponding VALUE passed,
%   PARAM and VALUE should be passed as pairs.
%
%   OPTIONS = GAOPTIMSET(OLDOPTS,'PARAM',VALUE) will create a structure named 
%   OPTIONS.  OPTIONS is created by altering the PARAM specified of OLDOPTS to
%   become the VALUE passed.  
%
%   OPTIONS = GAOPTIMSET(OLDOPTS,'PARAM1',VALUE1,'PARAM2',VALUE2,...) will
%   reassign those fields in OLDOPTS specified by PARAM1, PARAM2, ... to 
%   VALUE1, VALUE2, ...
%
%GAOPTIMSET PARAMETERS
%   
%   PopulationType      - The type of Population being entered
%                       [ 'bitstring' | 'custom' | {'doubleVector'} ]
%   PopInitRange        - Initial range of values a population may have
%                       [ Matrix  | {[-10;10]} ]
%   PopulationSize      - Positive scalar indicating the number of individuals
%                       [ positive scalar ]
%   EliteCount          - Number of best individuals that survive to next 
%                         generation without any change
%                       [ positive scalar | 0.05*PopulationSize ]
%   CrossoverFraction   - The fraction of genes swapped between individuals
%                       [ positive scalar | {0.8} ]
%   ParetoFraction      - The fraction of population on non-dominated front
%                       [ positive scalar | {0.35} ]
%   MigrationDirection  - Direction that fittest individuals from the various
%                         sub-populations may migrate to other sub-populations
%                       ['both' | {'forward'}]  
%   MigrationInterval   - The number of generations between the migration of
%                         the fittest individuals to other sub-populations
%                       [ positive scalar | {20} ]
%   MigrationFraction   - Fraction of those individuals scoring the best
%                         that will migrate
%                       [ positive scalar | {0.2} ]
%   Generations         - Maximum number of generations allowed
%                       [ positive scalar ]
%   TimeLimit           - Maximum time (in seconds) allowed  
%                       [ positive scalar | {Inf} ]
%   FitnessLimit        - Minimum fitness function value desired 
%                       [ scalar | {-Inf} ]
%   StallGenLimit       - Number of generations over which cumulative
%                         change in fitness function value is less than TolFun
%                       [ positive scalar ]
%   StallTest           - Measure used to check for stalling
%                       [ 'geometricWeighted' | {'averageChange'} ]
%   StallTimeLimit      - Maximum time over which change in fitness function
%                         value is less than zero
%                       [ positive scalar | {Inf} ]
%   TolFun              - Termination tolerance on fitness function value
%                       [ positive scalar ]
%   TolCon              - Termination tolerance on constraints
%                       [ positive scalar | {1e-6} ]
%   InitialPopulation   - The initial population used in seeding the GA
%                         algorithm; can be partial
%                       [ Matrix | {[]} ]
%   InitialScores       - The initial scores used to determine fitness; used
%                         in seeding the GA algorithm; can be partial
%                       [ column vector | {[]} ]
%   NonlinConAlgorithm  - The algorithm used to handle nonlinear constraints
%                         within the GA algorithm
%                          [ 'penalty' | {'auglag'} ]
%   InitialPenalty      - Initial value of penalty parameter
%                          [ positive scalar | {10} ]
%   PenaltyFactor       - Penalty update parameter
%                          [ positive scalar | {100} ]
%   CreationFcn         - Function used to generate initial population
%                       [ @gacreationlinearfeasible | @gacreationuniform ]
%   FitnessScalingFcn   - Function used to scale fitness scores.
%                       [ @fitscalingshiftlinear | @fitscalingprop | @fitscalingtop |
%                         {@fitscalingrank} ]
%   SelectionFcn        - Function used in selecting parents for next generation
%                       [ @selectionremainder | @selectionuniform | 
%                         @selectionroulette  |  @selectiontournament | 
%                         @selectionstochunif ]
%   CrossoverFcn        - Function used to do crossover
%                       [ @crossoverheuristic | @crossoverintermediate | 
%                         @crossoversinglepoint | @crossovertwopoint | 
%                         @crossoverarithmetic | @crossoverscattered ]
%   MutationFcn         - Function used in mutating genes
%                       [ @mutationuniform | @mutationadaptfeasible |
%                         @mutationgaussian ]
%   DistanceMeasureFcn  - Function used to measure average distance of
%                         individuals from their neighbors
%                       [ {@distancecrowding} ]
%   HybridFcn           - Another optimization function to be used once GA 
%                         has normally terminated (for whatever reason)
%                       [ @fminsearch | @patternsearch | @fminunc | @fmincon | {[]} ]
%   Display              - Level of display 
%                       [ 'off' | 'iter' | 'diagnose' | {'final'} ]
%   OutputFcns          - Function(s) called in every generation. This is more   
%                         general than PlotFcns.
%
%   PlotFcns            - Function(s) used in plotting various quantities 
%                         during simulation
%                       [ @gaplotbestf | @gaplotbestindiv | @gaplotdistance | 
%                         @gaplotexpectation | @gaplotgenealogy | @gaplotselection |
%                         @gaplotrange | @gaplotscorediversity  | @gaplotscores | 
%                         @gaplotstopping | @gaplotmaxconstr | @gaplotrankhist |
%                         @gaplotpareto | @gaplotspread | @gaplotparetodistance | 
%                         {[]} ]
%   PlotInterval        - The number of generations between plotting results
%                       [ positive scalar | {1} ]
%   Vectorized           - Objective function is vectorized and it can evaluate
%                         more than one point in one call 
%                       [ 'on' | {'off'} ]
%   UseParallel         - Use PARFOR to evaluate objective and nonlinear 
%                         constraint functions.
%                       [ logical scalar | true | {false} ]


%   Copyright 2003-2014 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $  $Date: 2014/03/26 02:30:35 $

if (nargin == 0) && (nargout == 0)
    fprintf('          PopulationType: [ ''bitstring''      | ''custom''    | {''doubleVector''} ]\n');
    fprintf('            PopInitRange: [ matrix           | {[-10;10]} ]\n');
    fprintf('          PopulationSize: [ positive scalar ]\n');
    fprintf('              EliteCount: [ positive scalar  | {0.05*PopulationSize} ]\n');
    fprintf('       CrossoverFraction: [ positive scalar  | {0.8} ]\n\n');
    fprintf('          ParetoFraction: [ positive scalar  | {0.35} ]\n\n');
    
    fprintf('      MigrationDirection: [ ''both''           | {''forward''} ]\n');
    fprintf('       MigrationInterval: [ positive scalar  | {20} ]\n');
    fprintf('       MigrationFraction: [ positive scalar  | {0.2} ]\n\n');
    
    fprintf('             Generations: [ positive scalar ]\n');
    fprintf('               TimeLimit: [ positive scalar  | {Inf} ]\n');
    fprintf('            FitnessLimit: [ scalar           | {-Inf} ]\n');
    fprintf('           StallGenLimit: [ positive scalar ]\n');
    fprintf('               StallTest: [ ''geometricWeighted'' | {''averageChange''} ]\n');
    fprintf('          StallTimeLimit: [ positive scalar  | {Inf} ]\n');
    fprintf('                  TolFun: [ positive scalar ]\n\n');
    fprintf('                  TolCon: [ positive scalar  | {1e-6} ]\n\n');
    
    fprintf('       InitialPopulation: [ matrix           | {[]} ]\n');
    fprintf('           InitialScores: [ column vector    | {[]} ]\n\n');
    
    fprintf('      NonlinConAlgorithm: [ ''penalty'' | {''auglag''} ]\n');
    fprintf('          InitialPenalty: [ positive scalar | {10} ]\n');
    fprintf('           PenaltyFactor: [ positive scalar | {100} ]\n\n');

    fprintf('             CreationFcn: [ function_handle  | @gacreationuniform | @gacreationlinearfeasible ]\n');
    fprintf('       FitnessScalingFcn: [ function_handle  | @fitscalingshiftlinear  | @fitscalingprop  | \n');
    fprintf('                            @fitscalingtop   | {@fitscalingrank} ]\n');
    fprintf('            SelectionFcn: [ function_handle  | @selectionremainder    | @selectionuniform | \n');
    fprintf('                            @selectionroulette | @selectiontournament   | @selectionstochunif ]\n');
    fprintf('            CrossoverFcn: [ function_handle  | @crossoverheuristic  | @crossoverintermediate | \n'); 
    fprintf('                            @crossoversinglepoint | @crossovertwopoint | @crossoverarithmetic | \n');
    fprintf('                            @crossoverscattered ]\n');
    fprintf('             MutationFcn: [ function_handle  | @mutationuniform | @mutationadaptfeasible | \n');
    fprintf('                            @mutationgaussian ]\n');
    fprintf('      DistanceMeasureFcn: [ function_handle  | {@distancecrowding} ]\n');
    fprintf('               HybridFcn: [ @fminsearch | @patternsearch | @fminunc | @fmincon | {[]} ]\n\n');
    
    fprintf('                 Display: [ ''off'' | ''iter'' | ''diagnose'' | {''final''} ]\n');
    fprintf('              OutputFcns: [ function_handle  | {[]} ]\n');
    fprintf('                PlotFcns: [ function_handle  | @gaplotbestf | @gaplotbestindiv | @gaplotdistance | \n');
    fprintf('                            @gaplotexpectation | @gaplotgenealogy | @gaplotselection | @gaplotrange | \n');
    fprintf('                            @gaplotscorediversity  | @gaplotscores | @gaplotstopping  | \n'); 
    fprintf('                            @gaplotmaxconstr | @gaplotrankhist | @gaplotpareto | @gaplotspread | \n');
    fprintf('                            @gaplotparetodistance |{[]} ]\n');
    fprintf('            PlotInterval: [ positive scalar  | {1} ]\n\n');
        
    fprintf('              Vectorized: [ ''on''  | {''off''} ]\n\n');
    fprintf('             UseParallel: [ logical scalar | true | {false} ]\n');
    return; 
end     

numberargs = nargin; 

%Return options with default values and return it when called with one output argument
options=struct('PopulationType', [], ...
               'PopInitRange', [], ...
               'PopulationSize', [], ...
               'EliteCount', [], ...
               'CrossoverFraction', [], ...
               'ParetoFraction', [], ...               
               'MigrationDirection',[], ...
               'MigrationInterval',[], ...
               'MigrationFraction',[], ...
               'Generations', [], ...
               'TimeLimit', [], ...
               'FitnessLimit', [], ...
               'StallGenLimit', [], ...
               'StallTest',[], ...
               'StallTimeLimit', [], ...
               'TolFun', [], ...
               'TolCon', [], ...
               'InitialPopulation',[], ...
               'InitialScores', [], ...
               'NonlinConAlgorithm',[], ...
               'InitialPenalty', [], ...
               'PenaltyFactor', [], ...
               'PlotInterval',[], ...
               'CreationFcn',[], ...
               'FitnessScalingFcn', [], ...
               'SelectionFcn', [], ...
               'CrossoverFcn',[], ...
               'MutationFcn',[], ...
               'DistanceMeasureFcn',[], ...               
               'HybridFcn',[], ...
               'Display', [], ...
               'PlotFcns', [], ...
               'OutputFcns', [], ...
               'Vectorized',[], ...
               'UseParallel', []);   


% If we pass in a function name then return the defaults.
if (numberargs==1) && (ischar(varargin{1}) || isa(varargin{1},'function_handle') )
    if ischar(varargin{1})
        funcname = lower(varargin{1});
        if ~exist(funcname,'file')
            error(message('globaloptim:GAOPTIMSET:functionNotFound',funcname));
        end
    elseif isa(varargin{1},'function_handle')
        funcname = func2str(varargin{1});
    end
    try 
        optionsfcn = feval(varargin{1},'defaults');
    catch ME
        error(message('globaloptim:GAOPTIMSET:noDefaultOptions',funcname));
    end
    % To get output, run the rest of psoptimset as if called with gaoptimset(options, optionsfcn)
    varargin{1} = options;
    varargin{2} = optionsfcn;
    numberargs = 2;
end

Names = fieldnames(options);
m = size(Names,1);
names = lower(Names);

i = 1;
while i <= numberargs
    arg = varargin{i};
    if ischar(arg)                         % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error(message('globaloptim:GAOPTIMSET:invalidArgument', i));
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = arg.(Names{j,:});
            else
                val = [];
            end
            if ~isempty(val)
                if ischar(val)
                    val = deblank(val);
                end
                options.(Names{j,:}) = checkfield(Names{j,:},val);
            end
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error(message('globaloptim:GAOPTIMSET:invalidArgPair'));
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            error(message('globaloptim:GAOPTIMSET:invalidArgFormat', i));
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error(message('globaloptim:GAOPTIMSET:invalidParamName', arg));
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                allNames = ['(' Names{j(1),:}];
                for k = j(2:length(j))'
                    allNames = [allNames ', ' Names{k,:}];
                end
                allNames = sprintf('%s).', allNames);
                error(message('globaloptim:GAOPTIMSET:ambiguousParamName',arg,allNames));
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = (deblank(arg));
        end
        options.(Names{j,:}) = checkfield(Names{j,:},arg);
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error(message('globaloptim:GAOPTIMSET:invalidParamVal', arg));
end


%-------------------------------------------------
function value = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%

% empty matrix is always valid
if isempty(value)
    return
end

switch field
    case {'PopulationType','MigrationDirection'}
        if ~isa(value,'char') 
            error(message('globaloptim:GAOPTIMSET:checkfield:NotAString','OPTIONS',field));
        end
        
    case {'FitnessScalingFcn','SelectionFcn','CrossoverFcn','MutationFcn',...
                'CreationFcn','HybridFcn','PlotFcns','OutputFcns','DistanceMeasureFcn'}
        if ~(iscell(value) ||  isa(value,'function_handle'))
            error(message('globaloptim:GAOPTIMSET:checkfield:NotAFunctionOrCellArray','OPTIONS',field));
        end
        
    case {'ParetoFraction','CrossoverFraction','MigrationInterval','PlotInterval','TolCon', ...
                'TolFun','MigrationFraction','TimeLimit','StallTimeLimit','FitnessLimit','StallGenLimit'} 
        if ~(isa(value,'double'))
            if ischar(value)
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosRealNumButString','OPTIONS',field));
            else
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosRealNum','OPTIONS',field));
            end
        end
    case {'PopInitRange'}
        % PopInitRange must be an array of finite doubles with 2 rows
        if ~(isa(value,'double')) || (size(value,1) ~= 2) || any(~isfinite(value(:)))
            error(message('globaloptim:GAOPTIMSET:checkfield:NotARangeType','OPTIONS',field));
        end
    case {'InitialPopulation','InitialScores','InitialPenalty','PenaltyFactor'}
       % The content is checked elsewhere.
    case {'Display'}
        validValues = {'off','none','iter','diagnose','final'};
        checkForValidStrings(field,value,validValues);
    case {'Vectorized'}
        if ~isa(value,'char') || ~any(strcmp(value,{'on','off'}))
            error(message('globaloptim:GAOPTIMSET:checkfield:NotOnOrOff','OPTIONS',field,'off','on'));
        end
     case {'Generations'} % integer including inf or default string
        if ~(isscalar(value) && isa(value,'double') && value >= 0) && ...
                ~strcmpi(value, '200*numberOfVariables') && ...
                ~strcmpi(value, '100*numberOfVariables')
            if ischar(value)
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumericScalarButString','OPTIONS',field));                
            else
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumericScalar','OPTIONS',field));  
            end
        end
        
    case {'PopulationSize'} % integer including inf or default string
        if ~(isa(value,'double') && all(value(:) >= 0)) && ...
                ~strcmpi(value,'15*numberOfVariables') && ...
                ~strcmpi(value,'50 when numberOfVariables <= 5, else 200')
            if ischar(value)
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumericButString','OPTIONS',field));
            else
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumeric','OPTIONS',field));
            end
        end
    
    case 'EliteCount'
        if ~(isa(value,'double') && all(value(:) >= 0)) && ...
                ~strcmpi(value,'0.05*PopulationSize') 
            if ischar(value)
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumericButString','OPTIONS',field));
            else
                error(message('globaloptim:GAOPTIMSET:checkfield:NotAPosNumeric','OPTIONS',field));
            end
        end
    case 'UseParallel'
        [value,valid] = validateopts_UseParallel(value,false,true);
        if  ~valid
            error(message('globaloptim:GAOPTIMSET:checkfield:NotLogicalScalar','OPTIONS',field));
        end
    case 'StallTest'
        validValues = {'averageChange','geometricWeighted'};
        checkForValidStrings(field,value,validValues);
    case 'NonlinConAlgorithm'
        validValues = {'auglag','penalty'};
        checkForValidStrings(field,value,validValues);
    otherwise
        error(message('globaloptim:GAOPTIMSET:unknownOptionsField'))
end    

%--------------------------------------------------------------------------
function checkForValidStrings(fieldName,val,validStrs)
if ~ischar(val) || ~any(strcmp(val,validStrs))
    error(message('globaloptim:GAOPTIMSET:checkfield:NotAValidString', ...
        'OPTIONS',fieldName,strjoin(validStrs,', ') ));
end
