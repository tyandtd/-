function line1 = find_V_line(sphere1_d_c,sphere2_d_c,sphere3_d_c)
%UNTITLED2 此处显示有关此函数的摘要
%% 椭圆拟合算法
 
ellipse1 = ellipseFit(sphere1_d_c);
ellipse2 = ellipseFit(sphere2_d_c);
ellipse3 = ellipseFit(sphere3_d_c);

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

%求无穷远直线，和球心投影
%球1对应
line1 = [out_dot1(2)-out_dot2(2);-(out_dot1(1)-out_dot2(1));(out_dot1(1)*out_dot2(2)-out_dot1(2)*out_dot2(1))];
%line1 = crossProduct(out_dot1,out_dot2);
line1 = line1/line1(3);
plot(sphere1_d_c(1,:),sphere1_d_c(2,:),sphere2_d_c(1,:),sphere2_d_c(2,:),sphere3_d_c(1,:),sphere3_d_c(2,:),V1(1,:),V1(2,:),V2(1,:),V2(2,:),V3(1,:),V3(2,:));                      
end