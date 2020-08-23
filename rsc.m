function [labels,profit] = rsc(set_profile,counts,md)
%RSC - Label a set of objects
%   [LABELS,PROFIT] = RSC(SET_PROFILE) uses the Restricted
%   Classification (rsc) method to label the elements of a set in c
%   classes. PROFIT is the sum of the posterior probabilities for the
%   label assignment
%
%   SET_PROFILE is an M-by-c matrix where each row is a data point in
%   the set. The columns are probability estimates for the c classes.
%   Thus, each row of set_profile should sum up to 1.
%
%   [LABELS,COST] = RSC(SET_PROFILE,COUNTS) allows for specifying the
%   maximum allowed number of objects from each class in the set. If
%   COUNTS is a scalar, all classes are allowed that number of objects.
%   If COUNTS is a vector, it must have c elements, one for each class.
%   The default value of COUNTS is 1.
%
%   [LABELS,COST] = RSC(SET_PROFILE,COUNTS,MD) allows for choosing
%   a method. MD is an integer between 1 and 4:
%
%       1: Hungarian assignment algorithm (default)
%       2: Greedy assignment
%       3: Sampling from the posterior probability distribution
%       4: Naive labelling by the original classifier
%          (largest posterior probability)
%
%   Examples:
%        set_profile = [ 0.53 0.23 0.24
%                        0.55 0.36 0.09
%                        0.21 0.50 0.29
%                        0.50 0.33 0.17];
%          counts = [2,1,2];
%          [labels,profit] = rsc(set_profile,counts,2)
%
%   Source: Kuncheva L. I., J. J. Rodríguez and A. S. Jackson, Restricted 
%           Set Classification: Who is there?, Pattern Recognition, 63, 
%           2017, 158–170. p. 161
%           https://lucykuncheva.co.uk/papers/lkjrajpr17.pdf
%
% -----
% Author: Lucy Kuncheva
% Date: 20/08/2020
% -------------------------------------------------------------------

% Assign missing inputs
if nargin < 3, md = 1; end
if nargin == 1, counts = 1; end

% ----- Augment set_profile
N = size(set_profile,1); % number of objects in the set
c = size(set_profile,2); % number of classes
k = counts;
Nk = sum(k); % the size of the augmented square matrix
if isscalar(counts), k = ones(1,c)*counts; end % class counts
p = []; % the augmented set
cl = []; % column labels
for i = 1:c % Add columns for each class
    p = [p repmat(set_profile(:,i),1,k(i))]; %#ok<*AGROW>
    cl = [cl, ones(1,k(i))*i];
end
p = [p; ones(Nk-N,Nk)/c]; % add rows with equal priors 1/c

% ----- Apply the matching algorithm
profit = 0; labels = zeros(N,1);

switch md
    case 1 % Hungarian algorithms

        match = assignment_hungarian(-log(p+eps));
        for i = 1:N
            labels(i) = cl(find(match(i,:))); %#ok<*FNDSB>
            profit = profit + set_profile(i,labels(i));
        end
        
    case 2 % Greedy assignment
        
        for i = 1:N
            p

            [maxProb,indMax] = max(p,[],2); % find max posteriors
            [~,indObj] = max(maxProb); % find max of the max
            labels(indObj) = cl(indMax(indObj));
            labels
            pause
            profit = profit + set_profile(indObj,labels(indObj));
            % eliminate the class (column) and the object (row)
            [p(indObj,:), p(:,indMax(indObj))] = deal(-inf);
        end
        
    case 3 % Sampling from the posterior probability distribution
        
        p = p ./ repmat(sum(p,2),1,Nk); % ensure the row sum is 1
        cu = cumsum(p,2);
        class_labels_left = cl;
        
        for i = 1:N            
            t = rand; % find in which label interval this value falls
            lab = 1;           
            while t > cu(i,lab)
                lab = lab + 1;
            end            
            labels(i) = class_labels_left(lab);
            profit = profit + set_profile(i,labels(i));
            
            % eliminate the class
            p(:,lab) = [];
            class_labels_left(lab) = [];
            
            % re-normalise
            p = p ./ repmat(sum(p,2),1,size(p,2));
            cu = cumsum(p,2);            
        end      
        
    case 4 % Naive labelling provided by the original classifier

        [probs,labels] = max(set_profile,[],2);
        profit = sum(probs);
end



