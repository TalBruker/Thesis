function average_s_epsilon_mat = run_statistic_fatigued_models(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, activation_func,number_of_models, noise_vector, s_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    
    %epsilon = vector of different epsilons
    if nargin < 12
        s_in = 500 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
    end
    if nargin < 11
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end

    % initialization
    epsilon_number_of_models = number_of_models * length(epsilon);
    epsilon_vec = zeros(epsilon_number_of_models,1);
    for i = 1:epsilon_number_of_models
       epsilon_vec(i) = epsilon(ceil(i/number_of_models));
    end
    epsilon_mat = ones([N,1]) * epsilon_vec.';
    s = s_in * ones([1, epsilon_number_of_models]);

    average_vec = zeros([1,iter_num]);
    %average_vec = zeros([1,iter_num]);
    average_s_matrix = zeros([epsilon_number_of_models,iter_num]);
%     s_matrix = zeros([iter_num, N]);
%     h_matrix = zeros([iter_num, N]);
    h = zeros(size(s));
    average_s_epsilon_mat = zeros(length(epsilon), number_of_models, iter_num);
    %f=waitbar(0,'Running Iteration Number 0-99');
    disp(['epsilon = ', num2str(epsilon)]);
    for i = 1:iter_num
        g = W*s + b - h;
        rate = activation_func(g);
        spike_vector = rand(size(s)) < delta_t * rate; % poissrnd(delta_t * rate);
        s = (1 - delta_t / tau_s) * s + spike_vector / tau_s;% + noise_vector.';  % activation_func(g) = spike_vector
        h = (1 - delta_t / tau_h) * h + epsilon_mat .* spike_vector / tau_s;
        average_s_matrix(:,i) = find_average_bump_location(s);
        if mod(i,round(iter_num/100)) == 0
            %waitbar(i/iter_num, f,['Running Iteration Number ',num2str(i),'-',num2str(i + round(iter_num/100))])
            disp(['Running Iteration Number ',num2str(i),'-',num2str(i + round(iter_num/100))])
        end
    end
    %waitbar(1,f,'Finishing');
    for i = 1:length(epsilon)
        start_index = 1+(i-1)*number_of_models;
        end_index = i*number_of_models;
        average_s_epsilon_mat(i,:,:) = average_s_matrix(start_index:end_index,:);
    end
end