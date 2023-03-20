function average_mat = run_multiple_models(N, W, b, delta_t, tau, iter_num, activation_func, number_of_models, noise_vector, s_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    if nargin < 9
        s_in = 500 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
    end
    if nargin < 8
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end
    
    %b = repmat(0,[1,N]);

    % initialization

    s = s_in * ones([1, number_of_models]);

    average_mat = zeros([number_of_models,iter_num]);

    f=waitbar(0,'Running Iteration Number 0-99');
    
    for i = 1:iter_num
        
        g = W*s + b;
        rate = activation_func(g);
        spike_vector = rand(size(g)) < delta_t * rate; % poissrnd(delta_t * rate);
        s = (1 - delta_t / tau) * s + spike_vector;% + noise_vector.';  % activation_func(g) = spike_vector
        % # noise_vector = np.array(list(map(int, np.random.uniform(size=N) < delta_t * noise_rate_vector)))
        average_mat(:,i) = find_average_bump_location(s);
        if mod(i,100) == 0
            waitbar(i/iter_num, f,['Running Iteration Number ',num2str(i),'-',num2str(i + 99)])
        end
    end
        
    waitbar(1,f,'Finishing');
    close(f)

end