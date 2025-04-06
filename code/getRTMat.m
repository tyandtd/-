function RTMat = getRTMat(roll,head,pitch,T)
%% 构造外参矩阵
R1 = [1,0,0;
    0,cos(pitch),-sin(pitch);
    0,sin(pitch),cos(pitch)];
R2 = [cos(head),0,sin(head);
    0,1,0;
    -sin(head),0,cos(head)];
R3 = [cos(roll),-sin(roll),0;
    sin(roll),cos(roll),0;
    0,0,1];
R = R3*R2*R1;
RTMat = [R,T(:)];
end