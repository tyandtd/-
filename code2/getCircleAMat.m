function Amat = getCircleAMat(p)
m1 = p(1);
m2 = p(2);
A = [m1^2,2*m1*m2,2*m1,m2^2,2*m2,1];
Amat = [real(A);imag(A)];
end