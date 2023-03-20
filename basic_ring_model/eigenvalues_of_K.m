N=1024;
tau = 1;
delta_t = 0.005;
iter_num = 100000;

W = MATRIX_CREATOR.create_w(@inter_func, N);
K = MATRIX_CREATOR.create_k(N, W,delta_t,tau,iter_num,@activation_func_derv);
    
% figure('Name','W');
% image(W,'CDataMapping','scaled')
% colorbar

x = 0:2*pi/N:2*pi*(1-1/N);
% figure('Name','g');
% plot(x,g);

% figure('Name','K');
% image(K,'CDataMapping','scaled')
% colorbar

eig_size = 5;
[V,D] = eigs(K,eig_size,'largestreal','MaxIterations',350);

[M,I] = max(diag(D));

figure('Name','maximal_eigenvector');
max_eigenvector = V(:,I);
plot(x,max_eigenvector);

[d,ind] = sort(diag(D),'descend');
Ds = D(ind,ind);
Vs = V(:,ind);
figure('Name','VS');
plot(x,Vs(:,1),x,Vs(:,2));

% fprintf('%4.2f',M)
% fprintf('%4.2f',K(1,1))