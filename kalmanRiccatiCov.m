function y=kalmanRiccatiCov(xposition,yposition,cov)




V=norm(xposition);
% R=cov*transpose(H)+V;
% Kk=cov*transpose(H)*R^-1;
% P=(eye(2)-Kk*H)*cov;
cov = cov-cov*(cov+diag([V,V]))^-1*cov;
y=cov;
end
