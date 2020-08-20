clear, clc, close all

% Source: Kuncheva L. I., J. J. Rodríguez and A. S. Jackson, Restricted
%           Set Classification: Who is there?, Pattern Recognition, 63,
%           2017, 158–170. p. 161
%           https://lucykuncheva.co.uk/papers/lkjrajpr17.pdf

set_profile = [0.53 0.23 0.24
    0.55 0.36 0.09
    0.21 0.50 0.29
    0.50 0.33 0.17];

counts = [2,1,2];

for i = 1:4 % check each mode
    [labels(:,i),profit(i)] = rsc(set_profile,counts,i); %#ok<*SAGROW>
end

% Table output

MethodNames = {'Hungarian','Greedy','Sample','Naive'};
RestrictionsHold = 'YYYN';

fprintf('| RSC Method  |  Labels  |   Profit  |  Restrictions hold? |\n')
fprintf('+-------------+----------+-----------+---------------------+\n')

for i = 1:4
    fprintf('| %10s  |  %i %i %i %i |',MethodNames{i},labels(:,i))
    fprintf('   %.4f  |          %1s          |\n',profit(i),...
        RestrictionsHold(i))
end
fprintf('+-------------+----------+-----------+---------------------+\n')
