% @brief Calculate the PageRank starting from a hyperlinks matrix.
% PageRank is calculated with 2 methods, Iterative & Algebraically.
%
% Generate an output file in same DIR with sources
% file and will print bot Algebraically & Iterative PageRanks
% and will make a ranking for every page.
%
% The most and the least page to show on searching engine.
% Showing for every page its belonging probabilty.
%
% @param file name of the file with hyperlinks for each page
% @param damp_fact float type number storing the value of
% the damping factor needed to calculate the page rank vector
% @param eps a tolerance/error to compute the page rank vector
% @return PageRank_Iterativ Iterative ranks vector 4 every page
% @return PageRank_Algebraic Algebraically ranks vector 4 every page
%    
function [PageRank_Iterativ, PageRank_Algebraic] = PageRank(file, damp_fact, eps)
    [FIN, open_err_r] = fopen (file, 'r');
    % Check if the IN FILE was opened
    if FIN < 0
        % Display error message
        disp(open_err_r);
    end

    newSubFolder = sprintf('%s/%s',"results");
    % Finally, create the folder if it doesn't exist already.
    if ~exist(newSubFolder, 'dir')
        mkdir(newSubFolder);
    end

    [~, name_out] = fileparts(file);
    name_out = sprintf("%s.out", name_out);
    [FOUT, open_err_w]  = fopen(fullfile(newSubFolder, name_out), 'w');
    % Check if the OUT FILE was opened
    if FOUT < 0
        % Display error message
        disp(open_err_w);
    end

    web_pages = fscanf(FIN, '%d', 1);

    % We initialize the adjacency matrix.
    HyperLinks = zeros(web_pages);

    % Traverse all nodes (web pages).
    for web_page = 1 : web_pages
        % The nodes to which the current page is adjacent
        page = fscanf(FIN, '%d', 1);
        % The number of links owned by node i.
        noHyperlinks = fscanf(FIN, '%d', 1);
        % Construct the adjacent matrix and vector of neighbors
        for hyperlink = 1 : noHyperlinks 
           % Go through all the nodes that are adjacent to current page
           HyperLink = fscanf(FIN, '%d', 1);
           % In case if the element is not on the main diagonal
           % and is adjacent with current page
           if HyperLink ~= page 
             HyperLinks(page, HyperLink) = 1;
           end
        end
     end

     % Parameters val1 = damp_factor & val2 = eps(tollerance)
     val1 = fscanf(FIN, '%f', 1);
     val2 = fscanf(FIN, '%f', 1);
     fclose(FIN);
   
     % Display PageRank for both methods.
     fprintf(FOUT, "No. web pages: %d\n\n", web_pages);

     % PageRank ITERATIV Display.
     PageRank_Iterativ = Iterative_PageRank(file, damp_fact, eps);
     fprintf(FOUT, "Iterative method:\n");
     for page = 1 : web_pages
       fprintf(FOUT, '%f\n', PageRank_Iterativ(page));
     end
     fprintf(FOUT, '\n');

     % PageRank ALGEBRIC Display.
     PageRank_Algebraic = Algebraic_PageRank(file, damp_fact);
     fprintf(FOUT, "Algebrical method:\n");
     for page = 1 : web_pages
       fprintf(FOUT, '%f\n', PageRank_Algebraic(page));
     end
     fprintf(FOUT, '\n');

     % Sortare descrescator rang pagini met algebraic
     PageList_Algebraic = PageRank_Algebraic;
     PageList_Algebraic = sortrows(PageList_Algebraic, 'descend');
     % Simple sort descending for all rows
     % for i = 1 : N - 1
       % for j = i + 1 : N
         % if PageList_Algebraic(i) < PageList_Algebraic(j)
           % aux = PageList_Algebraic(i);
           % PageList_Algebraic(i) = PageList_Algebraic(j);
           % PageList_Algebraic(j) = aux;
         % end
       % end
     % end

     % Display format for each line: (i j F).
     % i - current page analyzed
     % j - hyperlinks to the current page
     % F - probabilty that a user will access this page
     fprintf(FOUT, "PageRank List:\n");
     for i = 1 : web_pages
       for j = 1 : web_pages
         if PageList_Algebraic(i) == PageRank_Algebraic(j)
           fprintf(FOUT, '%d ', i);
           fprintf(FOUT, '%d ', j);
           break
         end
       end

       % The degree of belonging of the page.
       F = FuzzyLogic(PageList_Algebraic(i), val1, val2);
       fprintf(FOUT, '%f\n', F);
     end

    fclose(FOUT);
end
