function average_vec = run_statistic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, activation_func, simulation_number, noise_vector, s_in, h_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    
    if nargin < 12
        s_in = 500 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
    end
    if nargin < 13  %default origin state h_in
        h_in = zeros(size(s_in));
        
    end
    if nargin < 11
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end
    
    %b = repmat(0,[1,N]);

    % initialization

    s = s_in * ones([1, number_of_models]);

    %average_vec = zeros([1,iter_num]);
    average_s_matrix = zeros([simulation_number, iter_num]);
    %s_matrix = zeros([iter_num, N]);
    %h_matrix = zeros([iter_num, N]);
    h = h_in;

    for i = 1:iter_num
        
        g = W*s + b - h;
        rate = activation_func(g);
        spike_vector = poissrnd(delta_t * rate);
        s = (1 - delta_t / tau_s) * s + spike_vector / tau_s;% + noise_vector.';  % activation_func(g) = spike_vector
        h = (1 - delta_t / tau_h) * h + epsilon * spike_vector / tau_s;
        % average_vec(i) = find_average_bump_location(s);
        average_s_matrix(:,i) = find_average_bump_location(s);
    end

end