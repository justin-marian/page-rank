% @brief Calculate the PageRank starting from a hyperlinks matrix.
% Given a starting tolerance the algorithm will calculate the aproximate
% PageRank vector of all pages from the given hyperlinks matrix.
%
% @param file name of the file to read the hyperlinks matrix
% @param damp_fact floating point number storing the value of
% the damping factor needed to calculate the PageRank vector
% @param eps a tolerance to compute the PageRank for each page
% @return PageRank vector with the PageRank for each page
%
function [PageRank] = Iterative_PageRank(file, damp_fact, eps)
    % Set the number format
    format long
    % Try to open and read from file
    [FILE, open_err] = fopen (file, 'r');
    % Check if the was opened
    if FILE < 0
        % Display error message
        disp(open_err);
    end

    % Read pages number
    no_pages = fscanf(FILE, '%d', 1);

    % Initialize the adjacency matrix, hyperlinks matrix
    % Initialize the vector that holds the number of links for a page
    HyperLinks = zeros(no_pages);
    Links = zeros(no_pages);

    for page = 1 : no_pages 
       parent_page = fscanf(FILE, '%d', 1);
       no_links = fscanf(FILE, '%d', 1);
       Links(parent_page) = no_links;
       for link = 1 : no_links  
           hyperlink = fscanf(FILE, '%d', 1);
           if hyperlink ~= parent_page
             HyperLinks(parent_page, hyperlink) = 1;
           else
              Links(parent_page) = Links(parent_page) - 1; 
              % If there is already a link
              % Exclude the page itself from the calculation
           end
        end
    end

    % Close FILE, don't read anymore
    fclose(FILE);

    % BUILDING THE MATRIX OF INITIAL LINKS FOR EACH PAGE
    Links_Initial = zeros(no_pages);
    for i = 1 : no_pages
      for j = 1 : no_pages
        % If I have a link from j to i, j's PageRank increases
        % and the more his PageRank increases even more
        % depending on the no. of links from j -> i
        if HyperLinks(j, i) == 1
           Links_Initial(i, j) = 1. / Links(j);
        else
           Links_Initial(i, j) = 0;
        end
      end
    end

    % Calculate the R factor, the initial factor.
    % At the beginning all pages have the same PageRank(PR).
    PageRank_Initial = ones(no_pages, 1);
    PageRank = zeros(no_pages, 1);
    for i = 1: no_pages
       PageRank_Initial(i,1) = PageRank_Initial(i,1) * 1./no_pages;
    end
    
     % column vector that with 1s
    L(1:no_pages, 1) = 1; 

    while 1
      % R factor calculated for all N pages
      PageRank = damp_fact * Links_Initial * PageRank_Initial + ...
                 ((1 - damp_fact) ./ no_pages) * L;

      % Reached the desired precision, we stop
      % Convergence has been achieved: |R(t+1) - R(t)| <eps
      if norm(PageRank - PageRank_Initial) < eps 
        % The Euclidean norm was satisfied, the Crit.Cauchy convergence
        break;
      end

      PageRank_Initial = PageRank;
      % Refresh every time PageRank_Initial
      % (the PageRank factor at the previous moment of time t)
    end
end
