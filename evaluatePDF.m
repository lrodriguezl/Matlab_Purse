function [theo_pdf, theo_cdf] = evaluatePDF(pdfSelection,x,mu,sigma)
% formerly [theo_pdf, theo_cdf] = pdf_function(selection,x,mu,sigma)

switch pdfSelection
    case 1 % theoretical normal pdf and cdf
        theo_pdf = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
%         theo_pdf=normpdf(x,data_mu,data_sigma);
        theo_cdf=normcdf(x,mu,sigma);
    case 2 % theoretical laplace pdf and cdf
        beta = sigma / sqrt(2);
        z = abs(x - mu)./beta;
        theo_pdf = exp(-z) ./ (2*beta);
        x1= x(x<mu); x2=x(x>=mu);
        F1= 0.5.*exp((x1-mu)/beta);
        F2=1-0.5*exp(-(x2-mu)/beta);
        theo_cdf = [F1(:); F2(:)];
        
    case 3
end

theo_pdf = theo_pdf(:);
theo_cdf = theo_cdf(:);
end