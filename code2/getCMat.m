function CMat = getCMat(points)
%% ����ƽ������Բ��Ӧ�ľ���
% points ��ƽ���ϵĵ�
[~,n] = size(points);   %[����������]
A = zeros(n,6);
for i = 1:n
    A(i,1) = points(1,i) * points(1,i);
    A(i,2) = 2 * points(1,i) * points(2,i);
    A(i,3) = 2* points(1,i) * points(3,i);
    A(i,4) = points(2,i) * points(2,i);
    A(i,5) = 2 * points(2,i) * points(3,i);
    A(i,6) = points(3,i) * points(3,i);
end
[~,~,V] = svd(A);
vector = V(:,end);

CMat = [vector(1),vector(2),vector(3);
        vector(2),vector(4),vector(5);
        vector(3),vector(5),vector(6)];
end