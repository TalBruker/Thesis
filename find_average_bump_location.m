function bump_N = find_average_bump_location(v)
    % v must be a one dimentional vector.
    mat_size = size(v);
    N = mat_size(1);
    dN = N/(2*pi);
    N_arr = 1:N;
    theta_arr = N_arr/dN;
    theta_exp = exp(1i*theta_arr);
    theta_sum = theta_exp * v;
    theta = angle(theta_sum);
    bump_N = mod(theta * dN, N);
    
end