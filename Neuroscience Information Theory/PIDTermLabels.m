function [TermLabels] = PIDTermLabels(N)
%PIDTermLabels creates a list of the term labels to ease interpretation of
%the PID output.
%   [TermLabels] = PIDTermLabels(N) is a cellular array that contains the
%   term labels for the output of the PID function. It follows the notation
%   of Williams and Beer.
%
%   P. L. Williams and R. D. Beer, arXiv:1004.2515v1 (2010).
%
%   Inputs
%
%   N: The number of X variables in the PID calculation.
%
%   Outputs
%
%   TermLabels: A cellular array that contains the labels for the PID
%   terms.
%
%
%       Version 2.0

% Version Information
%
%   1.0: 10/6/11 - Original program created before and modified up to this
%   date. 
%
%   2.0: 3/20/13 - Program formatting modified for inclusion in the
%   toolbox. Also, printing term labels was replaced by a cellular array.
%   
%




% Obtain necessary lattice arrays from Lattice.
[SourcesMat,SetsMat,TransMat] = PIDLattice(N);

% First, label all of the sources. 

[NumSets,NumSources]=size(SetsMat);

for i=1:NumSources
    Var=find(SourcesMat(i,:)==1);
    templabel=['{'];
    for j=1:length(Var)
        templabel=[templabel,num2str(Var(j))];
    end
    templabel=[templabel,'}'];
    eval(['Source',num2str(i),'Label=templabel;']);
end

% Now label each set
TermLabels = cell([NumSets,1]);
for i=1:NumSets
    Sources=find(SetsMat(i,:)==1);
    templabel=[''];
    for j=1:length(Sources)
        eval(['templabel=[templabel,Source',num2str(Sources(j)),'Label];']);
    end
    TermLabels{i} = templabel;
end




end

