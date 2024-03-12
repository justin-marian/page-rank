% @brief Computes the belonging grade of one page according to its rank value. 
% The result [y] is calculated such that the fuzzy member fnc.
% This function is continuous & takes values from [0, 1] is a right. 
% Same for the values val1 & val2 takes values from [0, 1].
%
% @param PageRank computed page rank of one 
% one given page from hyperlinks matrix
% @param val1 left limit param for the page rank
% @param val2 second limit param for the page rank
% @return y the result of the member fuzzy function
function [y] = FuzzyLogic(PageRank, val1, val2)
    % Coefficients for calculating fuzzy logic
    a = 1 / (val2 - val1);
    b = - a * val1;

    if PageRank >= 0 && PageRank < val1
         y = 0;
    elseif PageRank >= val1 && PageRank <= val2
         y = a * PageRank + b;
    elseif PageRank > val2 && PageRank <= 1
         y = 1;
    else
        % Wrong input for page rank value
        y = PageRank .* inf;
    end
end