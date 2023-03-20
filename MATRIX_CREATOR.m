classdef MATRIX_CREATOR
    methods(Static)
        function W = create_w(w_function, N)
            W = zeros(N,N);
            for i = 1:N
                for j = 1:N
                    W(i,j) = w_function(abs(2*pi* (i - j) / N));
                end
            end
        end
        
        function K = create_k(N, W, b, delta_t,tau,iter_num,activiation_func,activation_func_derevative)
            g_func = activiation_func;
            [~,g] = calculate_g(N,W,delta_t,tau,iter_num,g_func, b);
            K = zeros(N,N);
            for i = 1:N
                for j = 1:N
                    delta = 0;
                    if i == j
                        delta = 1;
                    end
                    K(i,j) =-delta/tau + activation_func_derevative(g(i))*W(i,j);
                end
            end
        end
        
        function Z = create_nimrod_w(N, J0, J1)
            Z = zeros(N,N);
            for i = 1:N
                for j = 1:N
                    Z(i,j) =(J0 + 2*J1*cos(2*pi* (i - j) / N))/ (N);
                end
            end
        end
    end
end