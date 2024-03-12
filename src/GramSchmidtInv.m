function [Qinv] = GramSchmidtInv(A)
    % A = the Gram-Schmidt factorization matrix.
    % Calculate the inverse of the matrix A using Gram-Schmidth factorizations. 
    % I orthogonalize the set of vectors that appear instead of the initial set. 
    % After QR factorization, I solve the upper triangular system.

    [M, ~] = size(A);

    Q = zeros(M);
    % (orthonormalize the eigenvectors)->(orthogonal basis)

    R = zeros(M); 
    % R = upper triangular factor
    % (to obtain the upper triangular system)

    for C = 1 : M
      R(C, C) = norm(A(:, C), 2);
      Q(:, C) = A(:, C) / R(C, C);
      for L = C + 1 : M
        R(C, L) = Q(:, C)' * A(:, L);
        A(:, L) = A(:, L) - Q(:, C) * R(C, L);
      end
    end

    % Initialize the inverse square matrix
    % Solution for the superior triungular system
    Qinv = zeros(M);

    % Solve a liniar superior triungular system
    % GAUSSIAN ELIMINATION METHOD SIMPLE UPPER TRIANGULAR SYSTEM
    for L = M : -1 : 1
      % We calculate x(i) the solution ec. system Ax=b
      % For the reasons that we obtained a superior triangular system
      % The term x(N) = the respective free term, 
      % X(N-1) as a percentage of X(N) etc.
      mat_sum = zeros(M, 1);
      for C = L + 1 : M
         mat_sum = mat_sum + R(L, C) * Qinv(:, C);
      end
      % Update the inverse matrix column
      % We extract each column from the orthogonal matrix
      % Q in the column vector
      Qinv(:, L) = (Q(:, L) - mat_sum) ./ R(L, L);
    end
    
    % The upper triangular matrix will be Q^t * A
    Qinv = Qinv'; % inverse = transposed
end

    % Solution SUPERIOR TRIANGULAR SYSTEM:
    % A * x = b => Q * R * x = b => R * x = Q^t * b
    % O^t*Q = I => Q^-1 = Q^t <--> FOR ANY ORTHOGONAL MATRIX

    %%%%%%%%%%%%% GRAM-SCHMIDT CLASSIC ELEMENTS FOR Q & R %%%%%%%%%%%%%
    %                                    -                         -  %
    %                                    | r11 r12 r13 r14 ... r1n |  %
    %                                    |  0  r22 r23 r24 ... r2n |  %
    %  [a1 a2 ... an] = [q1 q2 ... qn] * |  0   0  r33 r34 ... r3n |  %
    %                                    |  0   0   0  r44 ... r45 |  %
    %                                    |  0   0   0   0  ... rnn |  %
    %                                    -                         -  %
    %      C = 1 : N   - all columns                                  %
    %      L = C+1 : N - we know that R is the matrix is              %
    %                    Superior triangular (ST)                     %
    %                    we work with elem above the main diagonal    %
    %                    the elements on the main diagonal            %
    %                    we get them at each step (column)            %
    %                                                                 %
    %      I . r(C,C) = |a(C) -SUM((r(L,C)*q(L)))|2, C = 1:i+l        %
    %                                                                 %
    %                                                                 %
    %      II. r(l,c) = q(l)^t*a(c)                                   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%  GRAM-SCHMIDT OPTIMIZED ELEMENTS PT QR  %%%%%%%%%%%%%
    % In CLASSIC GRAM-SCHMIDT we take each vector                     %
    % we orthogonalize it with all previous vectors compared to it    %
    %                                                                 %
    % In MODIFIED GRAM-SCHMIDT we take each vector                    %
    % and modify all the following vectors                            %
    % to be orthogonal to it                                          %
    %                                                                 %
    % Both methods perform the same ops.                              %
    % are mathematically equivalent                                   %
    % (although there may be small rounding errors)                   %
    %                                    -                         -  %
    %                                    | r11 r12 r13 r14 ... r1n |  %
    %                                    |  0  r22 r23 r24 ... r2n |  %
    %  [a1 a2 ... an] = [q1 q2 ... qn] * |  0   0  r33 r34 ... r3n |  %
    %                                    |  0   0   0  r44 ... r45 |  %
    %                                    |  0   0   0   0  ... rnn |  %
    %                                    -                         -  %
    %      a(c), q(l)  - columns c and l from mat. A and Q            %
    %                                                                 %
    %      the Q factor is obtained as a processing of the matrix A   %
    %      c = 1 : N - all columns                                    %
    %      l = c+1 : N - we know that R is the matrix is              %
    %                    Superior triangular (ST)                     %
    %                    we work with elem main diagonal              %
    %                                                                 %
    % I. r(c,c) = |a(c)|2, c = 1:N                                    %
    % q(c) = a(c) / r(c,c) - rounding instability                     %
    %                                                                 %
    % II. r(c,l) = q(c)^t * a(l), l = c+1:N                           %
    % a(l) = a(l) - q(c) * r(c,l)                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
