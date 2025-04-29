%% 初始控制，和基本参数生成
clear
clc
f = 600;aph = 1.1; s =1; u0 = 320; v0 = 240;
K = [aph*f s u0 ; 0 f v0 ; 0 0 1];%生成初始参数
c_point_T = [20,50,50,1];
% 设置一个外参数
RTMat1 = getRTMat(-pi/4,pi/7,-pi/6,c_point_T(1:3));
%得到相机的中心的坐标
c_point = - RTMat1(1:3,1:3)' * c_point_T(1:3)';
c_point = [c_point(1),c_point(2),c_point(3),1];

%% 球生成
%半径
sphere1_r = 40;
sphere2_r = 30;
sphere3_r = 30;
%投影球
sphere1_c = [1,0,0,1];
sphere2_c = [-30,-10,20,1];
sphere3_c = [20,-50,50,1];
%投影圆上的点
%确定取圆面上的点，相机位置
sphere1_c2c = c_point - sphere1_c;
sphere2_c2c = c_point - sphere2_c;
sphere3_c2c = c_point - sphere3_c;
%单位化
sphere1_c2c = sphere1_c2c/sqrt(sphere1_c2c*sphere1_c2c');
sphere2_c2c = sphere2_c2c/sqrt(sphere2_c2c*sphere2_c2c');
sphere3_c2c = sphere3_c2c/sqrt(sphere3_c2c*sphere3_c2c');
%确定圆上的任意一条单位向量
danwei1 = [-sphere1_c2c(2)/sphere1_c2c(1),1,0];
danwei2 = [-sphere2_c2c(2)/sphere2_c2c(1),1,0];
danwei3 = [-sphere3_c2c(2)/sphere3_c2c(1),1,0];

danwei1 = danwei1/sqrt(danwei1*danwei1');
danwei2 = danwei2/sqrt(danwei2*danwei2');
danwei3 = danwei3/sqrt(danwei3*danwei3');

%将单位向量旋转相应角度，得到圆上点的一圈单位点

dot_num =100;
sphere1_d = zeros(4,dot_num);
sphere2_d = zeros(4,dot_num);
sphere3_d = zeros(4,dot_num);
flag = 2*pi*(1:1:dot_num)/dot_num;
sphere1_d(1:3,:) = v_roll_u_bate(danwei1,sphere1_c2c,flag);
sphere2_d(1:3,:) = v_roll_u_bate(danwei2,sphere2_c2c,flag);
sphere3_d(1:3,:) = v_roll_u_bate(danwei3,sphere3_c2c,flag);
sphere1_d = sphere1_r*sphere1_d + sphere1_c';
sphere2_d = sphere2_r*sphere2_d + sphere2_c';
sphere3_d = sphere3_r*sphere3_d + sphere3_c';

%plot3(sphere3_d(1,:),sphere3_d(2,:),sphere3_d(3,:),sphere2_d(1,:),sphere2_d(2,:),sphere2_d(3,:),sphere1_d(1,:),sphere1_d(2,:),sphere1_d(3,:));
%% 投影圆映射到镜头变为椭圆

K_eva = zeros(3);

err_n = zeros(3,dot_num);
err_var = 25;
kk=0;

eq = 1000;
for jjj = 1:eq
%jjj
sphere1_d_c = K *RTMat1* sphere1_d;
sphere2_d_c = K *RTMat1* sphere2_d;
sphere3_d_c = K *RTMat1* sphere3_d;
% K_eva = zeros(3);
% 
% err_n = zeros(3,dot_num);
% err_var = 1;
% 
% eq = 100;
% for jjj = 1:eq

err_n = zeros(3,dot_num);
err_n(1:2,:) = randn(2,dot_num)*sqrt(err_var);
sphere1_d_c = sphere1_d_c /sphere1_d_c(3) + err_n;
err_n(1:2,:) = randn(2,dot_num)*sqrt(err_var);
sphere2_d_c = sphere2_d_c /sphere2_d_c(3)+ err_n;
err_n(1:2,:) = randn(2,dot_num)*sqrt(err_var);
sphere3_d_c = sphere3_d_c /sphere3_d_c(3) + err_n;
% 
% 
% sphere1_d_c = sphere1_d_c /sphere1_d_c(3) ;
% 
% sphere2_d_c = sphere2_d_c /sphere2_d_c(3);
% 
% sphere3_d_c = sphere3_d_c /sphere3_d_c(3) ;
%hold on
plot(sphere1_d_c(1,:),sphere1_d_c(2,:),'d',sphere2_d_c(1,:),sphere2_d_c(2,:),'d',sphere3_d_c(1,:),sphere3_d_c(2,:),'d');


% eq = 100;
% for jjj = 1:eq

    %% 椭圆拟合算法
     
    ellipse1 = getCMat(sphere1_d_c);
    ellipse2 = getCMat(sphere2_d_c);
    ellipse3 = getCMat(sphere3_d_c);
    
    if ellipse1(1) < 0 % 保持首项为正
        ellipse1 = -ellipse1;
    end
    if ellipse2(1) < 0
        ellipse2 = -ellipse2;
    end
    if ellipse3(1) < 0
        ellipse3 = -ellipse3;
    end
    
    %% 求特征向量，得到公共自极三点形
    %1和2
    [V1, D1] = eig(ellipse1\ellipse2);
    V1=V1./V1(3,:);
    %1和3
    [V2, D2] = eig(ellipse1\ellipse3);
    V2=V2./V2(3,:);
    %2和3
    [V3, D3] = eig(ellipse3\ellipse2);
    V3=V3./V3(3,:);
    
    %% 由公共自极三点形得到无穷远直线与投影球心
    %1和2，检查椭圆外的点
    for i = 1:3
        if V1(:,i)' * ellipse2 * V1(:,i) > 0
            if V1(:,i)' * ellipse1 * V1(:,i) > 0
                 out_dot1 = V1(:,i)/V1(3,i);
            end
        end
    end
    %1和3，球投影外极点
    for i = 1:3
        if V2(:,i)' * ellipse1 * V2(:,i) > 0
            if V2(:,i)' * ellipse3 * V2(:,i) > 0
                out_dot2 = V2(:,i)/V2(3,i);
            end
        end
    end
    %2和3，球投影外极点
    for i = 1:3
        if V3(:,i)' * ellipse3 * V3(:,i) > 0
            if V3(:,i)' * ellipse2 * V3(:,i) > 0
                out_dot3 = V3(:,i)/V3(3,i);
            end
        end
    end
    
    %求无穷远直线，和球心投影（最后把球心投影的部分给删除了）
    %球1对应
    line1 = [out_dot1(2)-out_dot2(2);-(out_dot1(1)-out_dot2(1));(out_dot1(1)*out_dot2(2)-out_dot1(2)*out_dot2(1))];
    line1 = line1/line1(3);
    %球2对应
    line2 = [out_dot1(2)-out_dot3(2);-(out_dot1(1)-out_dot3(1));(out_dot1(1)*out_dot3(2)-out_dot1(2)*out_dot3(1))];
    line2 = line2/line2(3);
    %球3对应
    line3 = [out_dot3(2)-out_dot2(2);-(out_dot3(1)-out_dot2(1));(out_dot3(1)*out_dot2(2)-out_dot3(2)*out_dot2(1))];
    line3 = line3/line3(3);
    
    %% Cholesky分解
    
    % step1: 求解圆环点的像（圆C1的像与消失线交点）
    circlePoints1 = getCirclePoints(line1,ellipse1);
    circlePoints2 = getCirclePoints(line2,ellipse2);
    circlePoints3 = getCirclePoints(line3,ellipse3);
    % step2: 利用圆环点求解inv(K.T)*inv(K)
    circleAMat = [getCircleAMat(circlePoints1(:,1));
                  getCircleAMat(circlePoints2(:,1));
                  getCircleAMat(circlePoints3(:,1))];
    %circleAMat
    [~,~,V] = svd(circleAMat);
    V = V(:,end);
    % step3: 使用cholesky分解求解K
    circleK = getKMat(V);
    if ~isreal(circleK)
        kk=kk+1;
        continue
    end
    K_eva = circleK+K_eva;
    K_look = K_eva/jjj;

end


K_eva = K_eva / (eq-kk);
% step4: 计算误差
disp('使用圆环点的误差：')
disp( K_eva);
disp('使用圆环点的误差的比：')
disp(abs(K - K_eva)./K);







