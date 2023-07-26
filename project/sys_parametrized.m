function [z, lambda] = sys_parametrized(n, m, pole, t, u, y)
    syms s
    
    DY = cell(1,n);  
    for i = 1:1:n 
        DY{i} = sym2poly(s^(n - i));
    end
    
    DU = cell(1,m + 1); 
    for i = 1:m+1
        DU{i} = sym2poly(s^(m + 1 - i));
    end
    
    L = (s + pole)^n; % single pole filter of order n => guarantees stability
    L = expand(L);
    lambda = sym2poly(L); 
    
    zy = cell(1,n); 
    for i = 1:1:n 
        zy{i} = tf(-DY{i},lambda);
    end
    
    zu = cell(1,m+1); 
    for i = 1:1:m+1  
        zu{i} = tf(DU{i},lambda);
    end
    
    z = zeros(length(t), n + m + 1);
    for j = 1:n + m + 1
       if j <= n
           z(:,j) = lsim(zy{j}, y, t);
       else
           z(:,j) = lsim(zu{j - n}, u, t); 
       end
    end

end
