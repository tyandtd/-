function v0 = v_roll_u_bate(v,u,bates)
%本函数目的是为了将v向量绕u向量旋转bate角度
v0 = [];
for bate = bates
   ttt = [0,-u(3),u(2);u(3),0,-u(1);-u(2),u(1),0];
    R = eye(3) + sin(bate) * ttt + (1 - cos(bate))*ttt*ttt;
    v0 = [v0,R * v'];

end

end