%% 分离圆标定的仿真实验
clear;
clc;
%% 初始化参数
circle_center1 = [1,1];    % 圆心坐标
circle_center2 = [25,40]; 
circle_center3 = [-40,-20]; 
circle_r1 = 20;     % 圆c1的半径
circle_r2 = 15;     % 圆c2的半径
circle_r3 = 18;     % 圆c2的半径
initial_K = [660,1,400;
    0,600,300;
    0,0,1];     % 内参
% 外参矩阵
RTMat1 = getRTMat(-pi/4,pi/7,-pi/6,[20,50,50]);
RTMat2 = getRTMat(pi/6,pi/8,-pi/8,[20,50,60]);
RTMat3 = getRTMat(-pi/20,pi/6,-pi/6,[20,50,70]);


%% 构造空间点和像平面的点 [p1,p2,p3]
num = 100;   % 点的个数
% 空间点的齐次坐标
C1Points = zeros(4,num);
C2Points = zeros(4,num);
C3Points = zeros(4,num);
i = 1;
for theta = linspace(0,2*pi,num+1)
    if theta == 2*pi
        break;
    else
        C1Points(1,i) = circle_r1 * cos(theta) + circle_center1(1);
        C2Points(1,i) = circle_r2 * cos(theta) + circle_center2(1);
        C1Points(2,i) = circle_r1 * sin(theta) + circle_center1(2);
        C2Points(2,i) = circle_r2 * sin(theta) + circle_center2(2);
        C3Points(1,i) = circle_r3 * cos(theta) + circle_center3(1);
        C3Points(2,i) = circle_r3 * sin(theta) + circle_center3(2);
        C1Points(4,i) = 1;
        C2Points(4,i) = 1;
        C3Points(4,i) = 1;
    end
    i = i + 1;
end
K_eva = zeros(3);
eq = 100;
for jjj = 1:eq
    % 像平面的坐标
    % figure1
    err_n = zeros(3,num);
    err_var = 100;
    
    C1ImagePoints1 = initial_K * RTMat1 * C1Points;
    C2ImagePoints1 = initial_K * RTMat1 * C2Points;
    C3ImagePoints1 = initial_K * RTMat1 * C3Points;
    
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C1ImagePoints1 = C1ImagePoints1./C1ImagePoints1(end,:)+err_n;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C2ImagePoints1 = C2ImagePoints1./C2ImagePoints1(end,:)+err_n;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C3ImagePoints1 = C3ImagePoints1./C3ImagePoints1(end,:)+err_n;
    
    
    
    % figure2
    C1ImagePoints2 = initial_K * RTMat2 * C1Points;
    C2ImagePoints2 = initial_K * RTMat2 * C2Points;
    
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C1ImagePoints2 = C1ImagePoints2./C1ImagePoints2(end,:)+err_n;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C2ImagePoints2 = C2ImagePoints2./C2ImagePoints2(end,:)+err_n;
    
    C3ImagePoints2 = initial_K * RTMat2 * C3Points;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C3ImagePoints2 = C3ImagePoints2./C3ImagePoints2(end,:)+err_n;
    
    
    % figure3
    C1ImagePoints3 = initial_K * RTMat3 * C1Points;
    C2ImagePoints3 = initial_K * RTMat3 * C2Points;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C1ImagePoints3 = C1ImagePoints3./C1ImagePoints3(end,:)+err_n;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C2ImagePoints3 = C2ImagePoints3./C2ImagePoints3(end,:)+err_n;
    
    C3ImagePoints3 = initial_K * RTMat3 * C3Points;
    err_n(1:2,:) = randn(2,num)*sqrt(err_var);
    C3ImagePoints3 = C3ImagePoints3./C3ImagePoints3(end,:)+err_n;
    
    
    %plot(C1ImagePoints1(1,:),C1ImagePoints1(2,:),'d',C2ImagePoints1(1,:),C2ImagePoints1(2,:),'d',C3ImagePoints1(1,:),C3ImagePoints1(2,:),'d');
    
    %% 计算inv(C2)*C1及其特征向量，并求解圆心和消失线
    line1 = find_V_line(C1ImagePoints1,C2ImagePoints1,C3ImagePoints1);
    
    line2 = find_V_line(C1ImagePoints2,C2ImagePoints2,C3ImagePoints2);
    line3 = find_V_line(C1ImagePoints3,C2ImagePoints3,C3ImagePoints3);
    
    %% 方法1：利用圆环点进行标定
    % step1: 求解圆环点的像（圆C1的像与消失线交点）
    circlePoints1 = getCirclePoints(line1,ellipseFit(C1ImagePoints1));
    circlePoints2 = getCirclePoints(line2,ellipseFit(C1ImagePoints2));
    circlePoints3 = getCirclePoints(line3,ellipseFit(C1ImagePoints3));
    
    % step2: 利用圆环点求解inv(K.T)*inv(K)
    circleAMat = [getCircleAMat(circlePoints1(:,1));
                  getCircleAMat(circlePoints2(:,1));
                  getCircleAMat(circlePoints3(:,1))];
    [~,~,V] = svd(circleAMat);
    V = V(:,end);
    
    
    % step3: 使用cholesky分解求解K
    circleK = getKMat(V);
    K_eva = circleK+K_eva;
    K_look = K_eva/jjj;
end
K_eva = K_eva / eq;
% step4: 计算误差
disp('使用圆环点的误差：')
disp( K_eva);
disp('使用圆环点的误差的比：')
disp((initial_K - K_eva)./initial_K);



