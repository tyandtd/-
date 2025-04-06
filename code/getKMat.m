function K = getKMat(c)
v0 = (c(2)*c(3)-c(1)*c(5))/(c(1)*c(4) - c(2)^2);
lambda = c(6) - (c(3)^2 + v0*(c(2)*c(3)-c(1)*c(5)))/c(1);
fu = sqrt(lambda/c(1));
fv = sqrt(lambda*c(1)/(c(1)*c(4)-c(2)^2));
s = -c(2)*fu*fu*fv/lambda;
u0 = s*v0/fu - c(3)*fu*fu/lambda;
K = [fu,s,u0;0,fv,v0;0,0,1];
end