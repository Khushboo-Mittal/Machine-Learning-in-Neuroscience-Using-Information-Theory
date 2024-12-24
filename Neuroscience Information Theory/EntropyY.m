function [ENT] = EntropyY(CountsMat)
%EntropyY calculates the entropy in bits of all the Y variable in
%CountsMat.
%   [ENT] = EntropyY(CountsMat) is the entropy of the the Y variable in
%   CountsMat.
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
%   ENT: Entropy of the Y variable.
%
%
%       Version 2.0

% Version Information
%
%   1.0: 10/6/11 - The original version of the program was created before
%   and modified up to this data. 
%
%   2.0: 3/27/13 - The formatting of the program was modified for inclusion
%   in the toolbox. 
%



% Convert the CountsMat to a joint probability distribution. (Note, this
% will have no effect if the CountsMat is already the joint probability
% distribution.)
Pxy = CountsMat/sum(CountsMat(:));

% Find the probability distribution of the Y variable
Py = sum(Pxy(:,:),2);

% Calculate the entropy
Temp = - Py .* log2(Py);
Temp(~isfinite(Temp)) = 0;
ENT = sum(Temp(:));



end

