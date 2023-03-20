function [s,g] = calculate_g(N,W,delta_t,tau,iter_num,activation_func, b, sigma)
    
    s = zeros(N,1);
    if nargin < 7
        b = zeros(N,1);
    end
    if nargin < 8
        sigma = 1;
    end
    
    % initialization
    for i = 1:N
        s(i) = 500 * exp(-100 * (i - (N / 2)) * (i - (N / 2))/(N*sigma));
    end
%     x = 0:2*pi/N:2*pi*(1-1/N);
%     figure('Name','s');
%     plot(x,s);
    for i = 1:iter_num
        g = W*s + b;
        s = (1 - delta_t / tau) * s + delta_t * activation_func(g);
    end
end