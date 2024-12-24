function [MI] = MutualInfo(CountsMat)
%MutualInfo calculates the mutual information between Y and {X1,...XN}.
%   [MI] = MutualInfo(CountsMat) is the mutual information between the Y
%   variable and the X variables considered as one vector valued variable
%   {X1, ... XN}.
%
%   Inputs
%
%   CountsMat: An array that contains the counts (or joint probability 
%   values) of the various states of the variables. The first index 
%   corresponds to the state of the Y variable. The second through N+1 
%   indexes correspond to the states of the X1 to XN variables. 
%
%   Outputs
%
%   MI: The mutual information between Y and {X1, ... XN} in bits.
%
%
%       Version 2.0

% Version Information
%
%   1.0: 10/6/11 - The original version of the program was created before
%   and modified up to this data. 
%
%   2.0: 3/20/13 - The formatting of the program was modified for inclusion
%   in the toolbox. 
%



% Obtain the number of states for each variable
nS = size(CountsMat);

% Obtain the number of X variables
N = length(nS) - 1;

% Convert the CountsMat to a joint probability distribution. (Note, this
% will have no effect if the CountsMat is already the joint probability
% distribution.)
Pxy = CountsMat/sum(CountsMat(:));

% Find the joint probabilities for the Y and {X1,...XN} variables
Px = repmat(sum(Pxy,1),[nS(1),ones([1,N])]);
Py = repmat(sum(Pxy(:,:),2),[1,nS(2:end)]);

% Calculate the mutual information
temp = Pxy.*log2(Pxy./(Px.*Py));

% Matlab incorrectly gives states with Pxy = 0 a non-finite value. 
temp(~isfinite(temp)) = 0;

% Sum over the terms to get the mutual information
MI = sum(temp(:));



end

