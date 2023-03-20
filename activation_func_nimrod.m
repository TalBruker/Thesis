function y = activation_func_nimrod(x)
    y = x .* heaviside(x);
end