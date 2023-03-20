function D = calculate_D(N, g, tau, activation_func, activation_func_derv)
    derv_g = zeros([1,N]);
    for i = 1:N
        if i == 1
            derv_g(i) = N * (g(2) - g(N)) / (4 * pi);
        elseif i == N
            derv_g(i) = N * (g(1) - g(N - 1)) / (4 * pi);
        else
            derv_g(i) = N * (g(i + 1) - g(i - 1)) / (4 * pi);
        end
    end
    squared_derv_g = derv_g.^2;
    mone = squared_derv_g*activation_func(g);
    mechane = 2 * (tau*squared_derv_g*activation_func_derv(g)).^2;
    D = mone/mechane;
end

        