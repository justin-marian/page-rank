% @brief Calculate the page rank starting from a hyperlinks matrix.
% With GramSchmidth we can calculate the ivers of a matrix and with the
% Grade Matrix we can calculate the PageRank vector for all pages.
%
% @param file name of the file to read the hyperlinks matrix
% @param damp_fact floating point number storing the value of
% the damping factor needed to calculate the page rank vector
% @return page_rank a vector containing the page ranks for every page
%
function [PageRank] = Algebraic_PageRank(file, damp_fact)
    % Set number format
    format long
    % Try to open and read from file
    [FILE, open_err] = fopen (file, 'r');
    
    % Check if the was opened
    if FILE < 0
        % Display error message
        disp(open_err);
    end

    % Read no web pages
    no_pages = fscanf(FILE, '%d', 1);
    
    % Initialize the adjacency matrix, hyperlinks matrix
    % Initialize the vector that holds the number of links for a page
    Hyperlinks = zeros(no_pages);

    for page = 1 :no_pages
        parent_page = fscanf(FILE, '%d', 1);
        no_links = fscanf(FILE, '%d', 1);
        Links = fscanf(FILE, "%d", no_links);
        for link = 1 : no_links
            if Links(link) ~= parent_page
                Hyperlinks(parent_page, Links(link)) = 1;
            end
        end
    end

    % Close FILE, don't read anymore
    fclose(FILE);

    % Compute the number of hyperlinks for every page
    PageLinks = sum(Hyperlinks, 2);

    % Compute the page grade matrix
    PageGrades = zeros(no_pages);
    for page = 1 : no_pages
      PageGrades(page, page) = 1. / PageLinks(page);
    end

    % Compute the new hyperlinks matrix, including the damping factor
    Hyperlinks = eye(no_pages) - damp_fact .* ...
                 (PageGrades * Hyperlinks)';
    % Compute the page rank vector
    PageRank = GramSchmidtInv(Hyperlinks) * ...
               (((1 - damp_fact) ./ no_pages) .* ...
               ones(no_pages, 1));
end
