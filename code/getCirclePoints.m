function points = getCirclePoints(line,C)
%% 计算圆环点的像 line:消失线
a = line(1);
b = line(2);
c = line(3);
a11 = C(1,1);
a12 = C(1,2);
a13 = C(1,3);
a22 = C(2,2);
a23 = C(2,3);
a33 = C(3,3);

A = a11 - (2*a12*a)/b + a22 * (a/b)^2;
B = 2*a13 - (2*a12*c)/b + a22*(2*a*c)/b^2 - 2*a23*a/b;
C = a22*(c/b)^2 - (2*a23*c)/b + a33;


points = ones(3,2);
points(1,1) = (-B + sqrt(B^2 - 4*A*C))/(2*A);
points(2,1) = -(a/b)*points(1,1) - c/b;

points(1,2) = (-B - sqrt(B^2 - 4*A*C))/(2*A);
points(2,2) = -(a/b)*points(1,2) - c/b;



end