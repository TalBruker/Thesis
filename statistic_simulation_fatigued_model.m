N=5000;
tau_s = 0.001;
tau_h = 0.002;
delta_t = 0.00001;
iter_num = 60000;
simulation_number = 50000;
% epsilon = 0.4;
b = 10; %I_00.
%%
W = MATRIX_CREATOR.create_nimrod_w(N, -10, 8);
[s,g,h] = calculate_initial_state_fatigued_model(N,W,delta_t,tau_s,tau_h,0.6,500,@activation_func_nimrod, b,1);
for i = 1:round(N/2)
    s(i) = s(end-i);
end
s = (1/max(s)) * s;
% creating the initial state
%% Running a simple fatigued model - A simple model check
epsilon = 0.5;
number_of_epsilons = length(epsilon);
average_s_epsilon_mat = run_statistic_fatigued_models(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod,1, 0, s);
s_to_plot = zeros([length(average_s_epsilon_mat),1]);
s_to_plot(:) = average_s_epsilon_mat(1,1,:);
%% Now, I want to check how the standard deviation changed.
% in order to do that, I will increase delta_t and decrease the number of iterations., and use a lot of
% simulations.
delta_t = 0.00001;
iter_num = 3000;

%now calculating the msd using the helping functions:
average_bump_position = run_statistic_fatigued_models(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod,simulation_number, 0, s);

average_over_simulations = mean(average_bump_position,2);
average_position_mat = zeros(length(epsilon), iter_num);
average_position_mat(:,:) = average_over_simulations(:,1,:);
average_position_mat = average_position_mat.';
plot(average_position_mat)

%%
epsilon = 4.5;
number_of_epsilons = length(epsilon);
average_bump_position = run_statistic_fatigued_models(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod,simulation_number, 0, s);
%%
average_over_simulations = mean(average_bump_position,2);
average_position_mat = zeros(length(epsilon), iter_num);
average_position_mat(:,:) = average_over_simulations(:,1,:);
average_position_mat = average_position_mat.';
plot(average_position_mat)

%% CALCULATING MSD
msd_mat = (average_bump_position - average_bump_position(:,:,1)).^2;
msd_mat = mean(msd_mat,2);
average_msd_over_simulations = zeros(length(epsilon), iter_num);
average_msd_over_simulations(:,:) = msd_mat(:,1,:);
average_msd_mat = average_msd_over_simulations.';

%% PLOT
start_index = 10;
x = start_index:iter_num;
p = polyfit(log(x),log(average_msd_mat(start_index:iter_num)).',1);
% for epsilon = 3.8, p(1) = 1.0171 - not enought supperdiffusive for me.
x_log = log(start_index:iter_num);
y_fit = polyval(p,x_log);
figure('Name','average_msd');
plot(x_log,log(average_msd_mat(start_index:iter_num)).');
hold on
% plot(x_log,y_fit);
hold off
%%
% [s_matrix,h_matrix] = run_deterministic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, 500 * round(tau_h/tau_s), @activation_func_nimrod, 0, s);
% cutting the variance from the average position:
% if average_nump_location = round(N/2)
% wait until average_nump_location < round(N/10) or average_nump_location > round(9*N/10)
% calculate the average with the range of results
% s((N/3):(N/2 - 1)) = 0;

number_of_epsilons = 10;
s_ep = zeros(number_of_epsilons,N);
g_ep = zeros(number_of_epsilons,N);

hold on
index_arr = 1:number_of_epsilons;
% epsilon = index_arr/number_of_epsilons;
epsilon = 4:1/number_of_epsilons:5;
time = (1:iter_num)*delta_t;
for index = index_arr
    epsilon_i = index/number_of_epsilons;
    [s_matrix,~] = run_deterministic_fatigued_model(N, W, delta_t,...
        tau_s, tau_h, epsilon_i, b, iter_num, @activation_func_nimrod, 0, s,h);
    plot(time,find_average_bump_location(s_matrix.'))
end
eps = string(double(epsilon));
legend_array = "epsilon = " + eps;
legend(legend_array);
t = title('Average Bump Location for \epsilon = ' +...
    string(epsilon(1)) + ' to ' + string(epsilon(end)));
t.FontSize = 16;
xlabel('Time (seconds)')
ylabel('Average Bump Location')
hold off
%%
[s_matrix,~] = run_deterministic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod, 0, s);
average_s = find_average_bump_location(s_matrix.');
for i = 2000:iter_num
    if (average_s(i) < N/2 + 1) && (average_s(i) > N/2 - 1)
        s = s_matrix(i,:).';
        break
    end
end
figure('Name','initial_s');
plot(s);

[s_matrix,h_matrix] = run_deterministic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod, 0, s);
MOVIE_CREATOR.movie_from_fatigued_state(s_matrix, h_matrix, delta_t, 10);
all_vec_msd = zeros([simulation_number, iter_num]);

bump_location = zeros([1,iter_num]);
for i = 1:iter_num
    s_i = s_matrix(i,:);
    bump_location(i) = find_average_bump_location(s_i.');
end
figure('Name','average_location');
plot(bump_location);

% returned_average_vec = run_deterministic_fatigued_model(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod,0,s);
% figure('Name','average_bump_location');
% plot(returned_average_vec)

% running the symulations and averaging over them:
% f=waitbar(0,'Running Simulation Number 0-99');
% for i = 1:simulation_number
% 
%     average_vec = run_deterministic_fatigued_model(N, W, delta_t, tau, iter_num, @activation_func,0,s);
%     all_vec_msd(i,:) = ((2*pi/N)^2) * (average_vec-average_vec(1)).^2; % calculating the msd.
%     if mod(i,100) == 0
%         waitbar(i/simulation_number, f,['Running Simulation Number ',num2str(i),'-',num2str(i + 99)])
%     end
% 
% end
% waitbar(1,f,'Finishing');

% fitting a graph for the msd:
% average_msd = mean(all_vec_msd);
% x = 300:iter_num;
% x = x * delta_t;
% p = polyfit(x,average_msd(300:end),1);
% x_full = 1:iter_num;
% x_full = x_full * delta_t;
% y_fit = polyval(p,x_full);
% D_measured = p(1)/2
% figure('Name','average_msd');
% plot(x_full,average_msd);
% hold on
% plot(x_full,y_fit);
% hold off


% D = calculate_D(N, g, tau, @activation_func, @activation_func_derv)
% D from experiment is ~ 2.0377820518835507783676789297802e-7


% figure('Name','W');
% image(W,'CDataMapping','scaled')
% colorbar

% x = 0:2*pi/N:2*pi*(1-1/N);
% figure('Name','g');
% plot(x,g);

% figure('Name','K');
% image(K,'CDataMapping','scaled')
% colorbar