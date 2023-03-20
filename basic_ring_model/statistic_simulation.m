N=1024;
tau = 0.01;
delta_t = 0.00008;
iter_num = 42000;
simulation_number = 50000;
b=0;
%% 

W = MATRIX_CREATOR.create_w(@inter_func, N);
K = MATRIX_CREATOR.create_k(N, W, b, delta_t,tau,iter_num,@activation_func,@activation_func_derv);
[s,g] = calculate_g(N,W,delta_t,tau,iter_num,@activation_func, b);

% running the symulations and averaging over them:
%% 

all_vec_msd = zeros([simulation_number, iter_num]);

average_mat = run_multiple_models(N, W, b, delta_t, tau, iter_num, @activation_func, simulation_number, 0, s);
all_vec_msd = ((2*pi/N)^2) * (average_mat-average_mat(:,1)).^2; % calculating the msd.


% fitting a graph for the msd:
average_msd = mean(all_vec_msd);
x = 1000:iter_num;
p = polyfit(x,average_msd(1000:iter_num),1);
x_full = 1:iter_num;
y_fit = polyval(p,x_full);
D_measured = p(1)/(2 * delta_t)
figure('Name','average_msd');
plot(x_full,average_msd);
hold on
plot(x_full,y_fit);
hold off

%% 
% u_1 = ds/dtheta
u_1 = zeros(N,1);
    for i = 1:N
        if i == 1
            u_1(i) = N * (s(2) - s(N)) / (4 * pi);
        elseif i == N
            u_1(i) = N * (s(1) - s(N - 1)) / (4 * pi);
        else
            u_1(i) = N * (s(i + 1) - s(i - 1)) / (4 * pi);
        end
    end
%%
D = calculate_D(N, g, tau, @activation_func, @activation_func_derv)
% D from experiment is ~ 2.0377820518835507783676789297802e-7


% figure('Name','W');
% image(W,'CDataMapping','scaled')
% colorbar

x = 0:2*pi/N:2*pi*(1-1/N);
% figure('Name','g');
% plot(x,g);

% figure('Name','K');
% image(K,'CDataMapping','scaled')
% colorbar

% eig_size = 5;
% [V,D_eigenvalue] = eigs(K,eig_size,'largestreal','MaxIterations',35*10^20);
% [M,I] = max(diag(D_eigenvalue));


[u,d_u] = eigs(K,1,'largestreal','MaxIterations',35*10^20);

[v,d_v] = eigs(K.',1,'largestreal','MaxIterations',350000);
u = u.*(u_1.'*u_1)./(u_1.'*u);
v = v./(u.'*v);
plot(v)

D = v.^2.'* activation_func(g)/2

%%

[d,ind] = sort(diag(D),'descend');
Ds = D(ind,ind);
Vs = V(:,ind);
figure('Name','VS');
plot(x,Vs(:,1),x,Vs(:,2));

figure('Name','maximal_eigenvector');
plot(x,max_eigenvector);
% fprintf('%4.2f',M)
% fprintf('%4.2f',K(1,1))
x = 'code ended'
% save('long_simulations')