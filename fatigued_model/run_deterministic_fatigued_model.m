function [s_matrix,h_matrix] = run_deterministic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, activation_func, noise_vector, s_in, h_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    if nargin < 11
        s_in = 500 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
    end
    if nargin < 12
        h_in = zeros(size(s_in));
    end
    if nargin < 10
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end
    
    %b = repmat(0,[1,N]);

    % initialization

    s = s_in;

    %average_vec = zeros([1,iter_num]);
    s_matrix = zeros([iter_num, N]);
    h_matrix = zeros([iter_num, N]);
    h = h_in;

    for i = 1:iter_num
        
        g = W*s + b - h;
        rate = activation_func(g);
        s = (1 - delta_t / tau_s) * s + delta_t * rate / tau_s;% + noise_vector.';  % activation_func(g) = spike_vector
        h = (1 - delta_t / tau_h) * h + epsilon * delta_t * rate / tau_s;
        % # noise_vector = np.array(list(map(int, np.random.uniform(size=N) < delta_t * noise_rate_vector)))
        %average_vec(i) = find_average_bump_location(s);
        s_matrix(i,:) = s;
        h_matrix(i,:) = h;
    end

end