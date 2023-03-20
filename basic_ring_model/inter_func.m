function y = inter_func(x) % The interaction function between neurons.
    y = exp(cos(x) - 1)-exp(0.3*(cos(x)-1));
end
