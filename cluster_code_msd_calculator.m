N=5000;
tau_s = 0.001;
tau_h = 0.002;
delta_t = 0.00001;
iter_num = 60000;
simulation_number = 50000;
% epsilon = 0.4;
b = 10; %I_00.
slurm_arr_num = getenv("SLURM_ARRAY_TASK_ID");
slurm_arr_num = str2double(slurm_arr_num);
addpath('fatigued_model')
%%
W = MATRIX_CREATOR.create_nimrod_w(N, -10, 8);
[s,g,h] = calculate_initial_state_fatigued_model(N,W,delta_t,tau_s,tau_h,0.6,500,@activation_func_nimrod, b,1);
for i = 1:round(N/2)
    s(i) = s(end-i);
end
s = (1/max(s)) * s;
% creating the initial state
%% Now, I want to check how the standard deviation changed.
% in order to do that, I will increase delta_t and decrease the number of iterations., and use a lot of
% simulations.
delta_t = 0.00003;

iter_num = 3000;

epsilon=0.01 * slurm_arr_num + 0.4;
disp(['slurm_arr_num = ', num2str(slurm_arr_num)])
disp(['epsilon = ', num2str(epsilon)])

%now calculating the msd using the helping functions:
average_bump_position = run_statistic_fatigued_models(N, W, delta_t, tau_s, tau_h, epsilon, b, iter_num, @activation_func_nimrod,simulation_number, 0, s);

average_over_simulations = mean(average_bump_position,2);
average_position_mat = zeros(length(epsilon), iter_num);
average_position_mat(:,:) = average_over_simulations(:,1,:);
average_position_mat = average_position_mat.';

msd_mat = (average_bump_position - average_bump_position(:,:,1)).^2;
msd_mat = mean(msd_mat,2);
average_msd_over_simulations = zeros(length(epsilon), iter_num);
average_msd_over_simulations(:,:) = msd_mat(:,1,:);
average_msd_mat = average_msd_over_simulations.';
save(['average_msd_of_epsilon=',num2str(epsilon),',delta_t=',num2str(delta_t),',N=',num2str(N),'.mat'])