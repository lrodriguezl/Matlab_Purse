function generated_data = DataGenerator(mu,sigma,N,distribution)
switch distribution
    case 1
        % generate random normal data same size, mean and sigma as input
        generated_data = normrnd(mu,sigma,N,1);
    case 2
        data_beta = sigma / sqrt(2);
         % http://en.wikipedia.org/wiki/Laplace_distribution
        % Generating random variables according to the Laplace distribution
        u = rand(N,1)-0.5;
        generated_data = mu - data_beta * sign(u).* log(1- 2* abs(u));
    case 3
end
end