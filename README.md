# PageRank

[PageRank](./images/Rank.png) algorithm, used by Google's search engine, assigns an index to web pages, based on importance within interconnected networks.`PageRank` analyzes inbound hyperlinks based on quantity and quality to predict user visits.

To calculate a page's index, `PageRank` evaluates inbound links from important sources. The damping factor, representing user behavior, also influences rankings.

## Description

This is a very summarized `PageRank` algorithm that determines a page's importance through its incoming links. It starts by identifying the **M(A)** set of pages that link to page **A**, then assesses the importance of these linking pages by considering their inbound link counts **L(P)**.

The algorithm calculates the `PR(A)` probability that users will visit page `A`. This probability is influenced by the **damping factor**, denoted by `d`. The formula to calculate the **PageRank** index for **$\forall A$** pages:

$$PR(A) = \frac{1 - d}{N} + d \cdot \sum_{P \in M(A)} \frac{PR(P)}{L(P)} = \frac{1 - d}{N} + d \cdot (\frac{PR(B)}{L(B)} + \frac{PR(C)}{L(C)} + \frac{PR(D)}{L(D)} + \cdots) $$

This formula takes into account the importance of each page in set **M(A)**, as represented by their **PageRank** indices and the number of incoming links each of these pages has. The higher the **PageRank** indices of the linking pages and the fewer the number of incoming links, the higher the **PageRank** index of page **A** is.

## Iterative algorithm

The program takes **N** web resources and constructs an adjacency list graph, saving it in a file. It builds the adjacency matrix and calculates the PageRank vector.
The algorithm takes input parameters such as the file name, damping factor d, and tolerance eps. It outputs the PageRank vector.

- **$A(i,j) = 0$** if node **i** is not adjacent with the node **j**, otherwise **1**.
- **A** web page contains at least one link to another web page. This means that matrix resulted from iterative algorithm is invertible.
- Some pages will have a link to themselves, for easier navigation, so not all elements from main diagonal of matrix **A** are **0**. In analysis, these links are meaningless, so they will not be counted. **$A(i,i) = 0, \forall i \in [1, N]$**.

After reading the file, the code builds the matrix of initial links for each page, calculates the R factor, and initializes the PageRank vector with a value of `(1 / number of pages for each page)`.
The function then enters a while loop, which calculates the PageRank vector for each page using the formula:
$$PageRank = d \cdot L_0 \cdot PR_0 + (\frac{1 - d}{N})  \cdot L $$

- **$L$** is the matrix of initial links for each page
- **$PR_0$** is the previous value of the PageRank vector,
- **$d$** is the damping factor
- **$N$** is the number of pages
- **$L$** is a column vector with 1s.

The loop continues until the difference between the current and previous PageRank vectors is less than the specified tolerance eps.
Return the computed PageRank vector for each page. The code implements the Iterative PageRank algorithm to calculate PageRank using the provided hyperlinks matrix.

## Algebraic algorithm

This algorithm involves building the hyperlink matrix, calculating the stochastic matrix, and using power iteration to compute the PageRank vector.

- `Gram-Schmidt` algorithm computes the matrix inverse by solving equations separately for each line.
- `Algebraic` algorithm calculates the PageRank vector using the hyperlinks matrix and damping factor, utilizing the Gram-Schmidt algorithm to compute the inverse.

**The optimized Gram-Schmidt:** algorithm will be used to find **$Q$** and **$R$** matrices such that: **$T = Q · R$**

Based on the **$Q$** and **$R$** matrices, the function will then solve the n systems of equations. `Algebraic` function will calculate the **PageRank** vector using the hyperlinks matrix and the damping factor, and use the `Gram-Schmidt` algorithm to compute the inverse of the matrix.

## Usage

In the `images` folder, you will find examples illustrating how the functions are utilized and examples showcasing `input data` and `output data` formats.

- **Input:** contains detailed information about web resources and their corresponding links. Each line represents a web page, followed by the indices of pages it links to and two lines for damping factor and tolerance value.

- **Output:** the PageRank vector for each page, along with the final PageRank vector, and a comprehensive list of outgoing links with their corresponding PageRank values.
