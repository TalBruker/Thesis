function [s,g,h] = calculate_initial_state_fatigued_model(N,W,delta_t,tau_s, tau_h, epsilon, iter_num,activation_func, b, sigma)
    
    s = zeros(N,1);
    if nargin < 9
        b = zeros(N,1);
    end
    if nargin < 10
        sigma = 1;
    end
    
    % initialization
    for i = 1:N
        s(i) = 100 * exp(-100 * (i - (N / 2)) * (i - (N / 2))/(N*sigma));
    end
    s(round(N/3) : round(2*N/5)) = 0;
%     x = 0:2*pi/N:2*pi*(1-1/N);
%     figure('Name','s');
%     plot(x,s);
    h = zeros(size(s));
    for i = 1:iter_num
        g = W*s + b - h;
        rate = activation_func(g);
        s = (1 - delta_t / tau_s) * s + rate / tau_s;% + noise_vector.';  % activation_func(g) = spike_vector
        h = (1 - delta_t / tau_h) * h + epsilon * rate / tau_s;
    end
end