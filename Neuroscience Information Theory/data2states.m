%% DATA2STATES - converts raw data to states
% Converts raw data to states as pre-processing for information theoretic 
% analyses as implemented in instinfo.
%
% Syntax: [StatesRaster,MethodResults] = data2states(DataRaster, MethodAssign)
%
% Input:
%   DataRaster (cell array or double array) - trial data. If a double array
%       is used, it should be number of variables by number of time bins by
%       number of trials. If a cell array is used, it should have only one 
%       dimension and each element should be a double array with the 
%       dimensions listed above. Each element of the cell array is referred
%       to as a 'data category'.
%   MethodAssign (cell array) - sets the state conversion method to use for
%       each variable. The array is N by 4 where N is the total number of
%       variables. The first column contains an integer that marks the data
%       category. If there is only one data category, this column can be 
%       removed. The second column contains the variable number (e.g. 
%       value = 3 for the third variable of the data category specified in 
%       the first column). The third column contains a string label for the
%       method to use (see the full description of the methods below). The 
%       fourth column contains a cell array with parameters for the chosen 
%       method (see below). The same method is applied to a given variable 
%       across trials at a specific time bin. The same method is applied to
%       all time bins for a specified variable. If a variable is not listed
%       in the MethodAssign variable, it is assumed that the data are
%       already stated and the native method (see below) is applied.
%       *Side Note: For single trial data, the data are stated across all
%       time bins instead of across trials. The program automatically
%       detects single trial data. 
%
% State Conversion Methods:
%   Native - 'Nat'
%       Assumes the states are already specified in the DataRaster and does
%       not perform a conversion. This most often occurs with categorical 
%       data (e.g. state 1 (value = 1) and state 2 (value = 2)). 
%       Example:
%         MethodAssign(1,:) = {[1],[2],'Nat',{}}
%         For each time bin, copies states from DataRaster to StatesRaster
%         for data category 1 variable 2.
%   Uniform Width Bins - 'UniWB'
%       Divides the distance spanned by the values across trials at a given
%       time bin for a specified variable into n equally sized bins. n is
%       specified as the only value in the cell array in the fourth column
%       of MethodAssign.
%       Example:
%         MethodAssign(1,:) = {[1],[3],'UniWB',{[2]}}
%           For each time bin, divides the data for data category 1 
%           variable 3 into two equally sized bins (i.e. 2 states).
%   Uniform Counts Bins - 'UniCB'
%       Divides values across trials at a given time bin for a specified
%       variable into n bins with equal numbers of counts. n is specified
%       as the only value in the cell array in the fourth column of
%       MethodAssign. Note, when the data cannot be perfectly divided (due
%       to discrete repeats, for instance), values are grouped with lower
%       numbers. 
%       Example:
%         MethodAssign(1,:) = {[3],[2],'UniCB',{[4]}}
%           For each time bin, divides the data for data category 3 
%           variable 2 into 4 states with equal numbers of counts.
%   Maximum Mutual Information - 'MaxMI'
%       Divides values across trials at a given time bin for a specified
%       variable into n adjacent bins such that the bin assignment
%       maximizes the mutual information between the named variable and
%       another variable specified in the cell array in the fourth column
%       of MethodAssign. Note, the second variable must be converted to a
%       state by another method. That conversion will be processed before 
%       the maximum mutual information conversion. Note, n is currently 
%       limited to 2 or 3 to save computation time.
%       Example:
%         MethodAssign(1,:) = {[4],[1],'MaxMI',{[5],[2],[8],[3]}}
%           For each time bin, divides the data for data category 4 
%           variable 1 into 3 bins to maximize the mutual information with 
%           data category 5 variable 2 at time bin 8.
%   Poisson MLE - 'PoisMLE'
%       Divides the data by hidden Poisson states found via a maximum 
%       likelihood estimation algorithm. The algorithm assumes the data 
%       were generated by n distinct Poisson distributions with different 
%       means and likelihoods. n is specified as the first value in the 
%       cell array in the fourth column of MethodAssign. The second value 
%       in the cell array in the fourth column of MethodAssign specifies 
%       if the probability values for the states are set by the user 
%       ('set') or are left to the default values ('default', all states 
%       equally likely). It can be helpful in the parameter search 
%       algorithm to set the hidden state probabilities if they are known 
%       or suspected. In other words, if half the stimuli were type A and 
%       the other half were type B, we might expect the hidden state 
%       probabilities to be 0.5. The third value in the cell array in the 
%       fourth column of MethodAssign specifies the manual set values for 
%       the state probabilities. It can be a row vector if the same
%       probabilities are applied to all time bins, or a time bin by number
%       of states array where each row will be used for the corresponding
%       time bin. Note, probabilities should be normalized to 1 for each 
%       time bin. All data points are assigned to a state by the underlying
%       Poisson distribution that is most likely for each data point. Note,
%       this method should only be used for discrete data and is best 
%       applied for count data.
%       Example:
%         MethodAssign(1,:) = {[1],[2],'PoisMLE',{[3],'default',[]}}
%           For each time bin, divides the data for data category 1 
%           variable 2 using 3 Poisson distributions (at most three hidden 
%           states). The probabilities for these states are the default
%           value of all equally likely.
%         MethodAssign(1,:) = {[3],[1],'PoisMLE',{[2],'set',[0.75,0.25]}}
%           For each time bin, divides the data for data category 3 
%           variable 1 using 2 Poisson distributions (at most two hidden 
%           states). The probabilities for these states are set to 0.75 and
%           0.25. 
%   
%
% Outputs:
%   StatesRaster (cell array or double array) - trial state data. If a
%     double array is used, it should be number of variables by number of
%     time bins by number of trials. Each element should be an integer
%     state number (state number = 1, 2, 3, ...). If a cell array is used,
%     it should have only one dimension and each element should be a double
%     array with the dimensions listed above. Each element of the cell
%     array is referred to as a 'data category'.
%   MethodResults (cell array) - information about the resulting parameters
%     for the data stating. MethodResults will be N by 1, where N =
%     size(MethodAssign,1). Each element of MethodResults will correspond
%     to the matching row in MethodAssign. Results format for each method
%     are listed below:
%       MethodAssign{i,3} = 'Nat' implies MethodResults{i} will be an empty
%         vector.
%       MethodAssign{i,3} = 'UniWB' implies MethodResults{i} will be a
%         number of time bins by number of state bins + 1 array. Each row
%         will list the edges used to bin the data (following the rules for
%         edges established by histc) at a given time bin.
%       MethodAssign{i,3} = 'UniCB' implies MethodResults{i} will be a
%         number of time bins by number of state bins + 1 array. Each row
%         will list the edges used to bin the data (following the rules for
%         edges established by histc) at a given time bin.
%
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See symbolicdata2states for symbolic ranking state options.
%




function [StatesRaster,MethodResults] = data2states(DataRaster, MethodAssign)
%% Error check and preprocess

% Error check the DataRaster and the MethodAssign
if iscell(DataRaster)
    Back2ArrayFlag = false;
    if length(DataRaster) ~= 1
        if size(MethodAssign,2) ~= 4
            error('MethodAssign is not the appropriate size. Probably the data category is missing.')
        end
    else
        if size(MethodAssign,2) == 3
            NewMethodAssign = cell([size(MethodAssign,1),4]);
            for iVar = 1:size(MethodAssign,1)
                NewMethodAssign{iVar,1} = 1;
                NewMethodAssign{iVar,2} = MethodAssign{iVar,1};
                NewMethodAssign{iVar,3} = MethodAssign{iVar,2};
                NewMethodAssign{iVar,4} = MethodAssign{iVar,3};
            end
            MethodAssign = NewMethodAssign;
        elseif size(MethodAssign,2) ~= 4
            error('MethodAssign is not the appropriate size.')
        end
    end
else
    Back2ArrayFlag = true;
    DataRaster = {DataRaster};
    if size(MethodAssign,2) == 2
        NewMethodAssign = cell([size(MethodAssign,1),4]);
        for iVar = 1:size(MethodAssign,1)
            NewMethodAssign{iVar,1} = 1;
            NewMethodAssign{iVar,2} = MethodAssign{iVar,1};
            NewMethodAssign{iVar,3} = MethodAssign{iVar,2};
            NewMethodAssign{iVar,4} = MethodAssign{iVar,3};
        end
        MethodAssign = NewMethodAssign;
    end
end

% Make the coded MA [data category, variable number, methodID,
% methodParamID1, methodParamID2, methodParamID3, methodParamID4]
MA = zeros([size(MethodAssign,1),7]);
MACell = cell([size(MethodAssign,1),1]);
for iVar = 1:size(MethodAssign,1)
    
    % Copy the data category
    MA(iVar,1) = MethodAssign{iVar,1};
    
    % Copy the variable number
    MA(iVar,2) = MethodAssign{iVar,2};
    
    % Code the method and parameters
    if strcmp(MethodAssign{iVar,3},'Nat')
        MA(iVar,3) = 1;
    elseif strcmp(MethodAssign{iVar,3},'UniWB')
        MA(iVar,3) = 2;
        MA(iVar,4) = MethodAssign{iVar,4}{1};
    elseif strcmp(MethodAssign{iVar,3},'UniCB')
        MA(iVar,3) = 3;
        MA(iVar,4) = MethodAssign{iVar,4}{1};
    elseif strcmp(MethodAssign{iVar,3},'MaxMI')
        MA(iVar,3) = 5;
        MA(iVar,4) = MethodAssign{iVar,4}{1};
        MA(iVar,5) = MethodAssign{iVar,4}{2}; 
        MA(iVar,6) = MethodAssign{iVar,4}{3};
        MA(iVar,7) = MethodAssign{iVar,4}{4};
    elseif strcmp(MethodAssign{iVar,3},'PoisMLE')
        MA(iVar,3) = 4;
        MA(iVar,4) = MethodAssign{iVar,4}{1};
        if strcmp(MethodAssign{iVar,4}{2},'default')
        	MA(iVar,5) = 0;
        elseif strcmp(MethodAssign{iVar,4}{2},'set')
            MA(iVar,5) = 1;
            MACell{iVar,1} = MethodAssign{iVar,4}{3};
        end
    else
        error('Incorrect method.')
    end
end

% Error check the method assignments
if size(unique(MA(:,1:2),'rows'),1) ~= size(MA(:,1:2),1)
    error('Duplicate method assignments.')
end
for iVar = 1:size(MA,1);
    if MA(iVar,3) == 5
        Found = 0;
        Bad = 0;
        for jVar = 1:size(MA,1)
            if isequal(MA(jVar,1:2),MA(iVar,4:5))
                Found = 1;
                if MA(jVar,3) == 4
                    Bad = 1;
                end
            end
        end
        if (Found == 0) || (Bad == 1)
            error('Invalid maximum mutual information method.')
        end
    end
end
if MA(:,7) > 3
    error('Maximum Mutual Information bin number exceeded.')
end
for iVar = 1:size(MA,1)
    if MA(iVar,3) == 4
        if MA(iVar,5) == 1
            if MA(iVar,4) ~= length(MACell{iVar})
                error('Poisson MLE Error: the number of hidden states must equal the number of set probabilities')
            end
            if size(MACell{iVar},1) > 1
                for iT = 1:size(MACell{iVar},1)
                    if sum(MACell{iVar}(iT,:)) ~= 1
                        error('Poisson MLE: the set probabilities were not properly normalized.')
                    end
                end
            else
                if sum(MACell{iVar}) ~= 1
                    error('Poisson MLE: the set probabilities were not properly normalized.')
                end
            end
        end
    end
end


    
% Reorder the method assignment list to do maximum MI method last
[MA,I] = sortrows(MA,3);
MACell = MACell(I);

% Make the MethodResults array
MethodResults = cell([size(MethodAssign,1),1]);

% % Remove native format variables since they require no operations
% MACell(MA(:,3) == 1) = [];
% MA(MA(:,3) == 1,:) = [];



%% Make the StatesRaster

% Transfer over the DataRaster structure and the native variables
StatesRaster = DataRaster;

% Perform the state conversion
for iVar = (nnz(MA(:,3) == 1) + 1):size(MA,1) % Skip the native format
    
    % Get the data
    Temp1 = StatesRaster{MA(iVar,1)}(MA(iVar,2),:,:);
    if size(Temp1,3) == 1 % Single Trial Data
        STFlag = true;
        Temp1 = permute(Temp1,[1,3,2]);
    else
        STFlag = false;
    end
    
    if MA(iVar,3) == 2 % Uniform Width Bins
        
        % Get the number of bins to divide the data into
        nBins = MA(iVar,4);
        
        % Make space for the method results
        MethodResults{I(iVar)} = NaN([size(Temp1,2),nBins + 1]);
        
        % Go through each time bin and other subscripts and state the data
        for iT = 1:size(Temp1,2)
            Temp2 = squeeze(Temp1(1,iT,:));
            if length(unique(Temp2)) <= nBins
                [waste1,waste2,Temp1(1,iT,:)] = unique(Temp2);
                MethodResults{I(iVar)}(iT,1:length(unique(Temp2))) = unique(Temp2);
            else
                Edges = linspace(min(Temp2),max(Temp2),nBins + 1);
                Edges(1) = -inf;
                Edges(end) = inf;
                [waste,Temp2] = histc(Temp2,Edges);
                Temp1(1,iT,:) = Temp2;
                MethodResults{I(iVar)}(iT,:) = Edges;
            end
        end
        
    elseif MA(iVar,3) == 3 % Uniform Count Bins
        
        % Get the number of bins to divide the data into
        nBins = MA(iVar,4);
        
        % Make space for the method results
        MethodResults{I(iVar)} = NaN([size(Temp1,2),nBins + 1]);
        
        % Go through each time bin and other subscripts and state the data
        for iT = 1:size(Temp1,2)
            Temp2 = squeeze(Temp1(1,iT,:));
            if length(unique(Temp2)) <= nBins
                [waste1,waste2,Temp1(1,iT,:)] = unique(Temp2);
                MethodResults{I(iVar)}(iT,1:length(unique(Temp2))) = unique(Temp2);
            else
                
                % Rank the data points making sure to account for ties
                Temp3 = ceil(nBins * tiedrank(Temp2) / length(Temp2));
                
                % Check that ties don't accidentally remove possible bins
                nShadowBins = nBins;
                while length(unique(Temp3)) < nBins
                    nShadowBins = nShadowBins + 1;
                    Temp3 = ceil(nShadowBins * tiedrank(Temp2) / length(Temp2));
                end
                
                % Check that we didn't accidentally create too many states.
                % We'd rather have too few than too many.
                if length(unique(Temp3)) > nBins
                    Temp3 = ceil((nShadowBins - 1) * tiedrank(Temp2) / length(Temp2));
                end
                
                % Convert to states numbered 1 through nBins
                [waste1,waste2,Temp3] = unique(Temp3);
                
                Temp1(1,iT,:) = Temp3;
                MethodResults{I(iVar)}(iT,1) = -inf;
                for iBin = 2:nBins
                    if nnz(Temp3 == iBin) > 0
                        MethodResults{I(iVar)}(iT,iBin) = min(Temp2(Temp3 == iBin));
                    end
                end
                MethodResults{I(iVar)}(iT,nBins + 1) = inf;
            end
        end  
        
    elseif MA(iVar,3) == 5 % Maximum Mutual Information
        
        % Get data from the other variable to be used in the MI calculation
        Temp3 = squeeze(StatesRaster{MA(iVar,4)}(MA(iVar,5),MA(iVar,6),:));
        nUniqueTemp3 = length(unique(Temp3));
        
        % Make space for the method results
        MethodResults{I(iVar)} = NaN([size(Temp1,2),MA(iVar,7) + 1]);
        
        % Go through each time bin and other subscripts and state the data
        for iT = 1:size(Temp1,2)
            Temp2 = squeeze(Temp1(1,iT,:));
            SortedTemp2 = unique(Temp2)';
            if length(SortedTemp2) > 1
                Partitions = nchoosek(1:length(SortedTemp2),MA(iVar,7) - 1);
                nParts = size(Partitions,1);
                MIVals = zeros([nParts,1]);
                for iPart = 1:nParts
                    [waste,Temp4] = histc(Temp2,[-inf,SortedTemp2(Partitions(iPart,:)),inf]);
                    Counts = accumarray({Temp3,Temp4},ones(size(Temp3)),[nUniqueTemp3,MA(iVar,7)]);
                    MIVals(iPart) = MutualInfo(Counts);
                end
                iPart = find(MIVals == max(MIVals),1,'first');
                [waste,Temp4] = histc(Temp2,[-inf,SortedTemp2(Partitions(iPart,:)),inf]);
                Temp2 = Temp4;
                MethodResults{I(iVar)}(iT,:) = [-inf,SortedTemp2(Partitions(iPart,:)),inf];
            else
                Temp2 = ones(size(Temp2));
                MethodResults{I(iVar)}(iT,:) = [-inf,inf];
            end
            Temp1(1,iT,:) = Temp2;
        end
        
    elseif MA(iVar,3) == 4 % Poisson MLE
        
        nStates = MA(iVar,4);
        nData = size(Temp1,3);
        pManualFlag = logical(MA(iVar,5));
        
        % Make space for the method results
        MethodResults{I(iVar)} = NaN([size(Temp1,2),nStates + 1]);
        
        % Go through each time bin and extra variable
        for iT = 1:size(Temp1,2)
            
            Data = squeeze(Temp1(1,iT,:));
            
            % If there are few unique data values, just bin the data to
            % the unique values
            if length(unique(Data)) <= nStates
                
                [waste1,waste2,Temp1(1,iT,:)] = unique(Data);
                MethodResults{I(iVar)}(iT,1:length(unique(Data))) = unique(Data);
                
            else
                
                % Otherwise, use optimization to find the underlying states
                
                if pManualFlag
                    if size(MACell{iVar},1) > 1
                        p = MACell{iVar}(iT,:);
                    else
                        p = MACell{iVar};
                    end
                else
                    p = (1/nStates)*ones([1,nStates]);
                end
                lambdaStart = linspace(min(Data),max(Data),nStates + 2);
                lambdaStart([1,end]) = [];    
                negL = @(lambda) -sum(log(sum(repmat(p,[nData,1]).*repmat(lambda,[nData,1]).^repmat(Data,[1,nStates]).*repmat(exp(-lambda),[nData,1]),2)),1);
                lambda = fminsearch(negL,lambdaStart);
                
                % Assign each data point to the state with the maximum
                % probability
                [waste,Temp1(1,iT,:)] = max(squeeze(p(ones([1,nData]),:)).*...
                    squeeze(lambda(ones([1,nData]),:).^(Data(:,ones([1,nStates])))).*...
                    exp(-squeeze(lambda(ones([1,nData]),:))), [], 2);
                
                MethodResults{I(iVar)}(iT,1) = -inf;
                for iState = 2:nStates
                    MethodResults{I(iVar)}(iT,iState) = min(Data(squeeze(Temp1(1,iT,:)) == iState));
                end
                MethodResults{I(iVar)}(iT,nStates + 1) = inf;
                
 
            end
        end
        
    end
    
    % If this was single trial data, undo the dimension permutation
    if STFlag
        Temp1 = permute(Temp1,[1,3,2]);
    end
    
    % Put the stated data in the states raster
    StatesRaster{MA(iVar,1)}(MA(iVar,2),:,:) = Temp1;
    
end

% Convert StatesRaster back to an array, if necessary
if Back2ArrayFlag
    StatesRaster = StatesRaster{1};
end
        





