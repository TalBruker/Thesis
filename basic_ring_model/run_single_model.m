function average_vec = run_single_model(N, W, delta_t, tau, iter_num, activation_func, noise_vector, s_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    if nargin < 8
        s_in = 500 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
        
    end
    if nargin < 7
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end
    
    %b = repmat(0,[1,N]);

    % initialization

    s = s_in;

    average_vec = zeros([1,iter_num]);

    for i = 1:iter_num
        
        g = W*s;% + b;
        rate = activation_func(g);
        spike_vector = poissrnd(delta_t * rate);
        s = (1 - delta_t / tau) * s + spike_vector;% + noise_vector.';  % activation_func(g) = spike_vector
        % # noise_vector = np.array(list(map(int, np.random.uniform(size=N) < delta_t * noise_rate_vector)))
        average_vec(i) = find_average_bump_location(s);
    end

end