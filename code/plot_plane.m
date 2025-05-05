function plot_plane(normal, point)
    % 检查输入是否为三维向量
    if length(normal) ~= 3 || length(point) ~= 3
        error('输入必须为三维向量');
    end
    
    a = normal(1);
    b = normal(2);
    c = normal(3);
    d = dot(normal, point);
    
    % 确定法向量的主分量
    [~, idx] = max(abs(normal));
    
    % 设置网格范围和点数
    range = 10;
    num_points = 20;
    
    switch idx
        case 3  % 解z
            x = linspace(point(1)-range, point(1)+range, num_points);
            y = linspace(point(2)-range, point(2)+range, num_points);
            [X, Y] = meshgrid(x, y);
            Z = (d - a*X - b*Y) / c;
        case 2  % 解y
            x = linspace(point(1)-range, point(1)+range, num_points);
            z = linspace(point(3)-range, point(3)+range, num_points);
            [X, Z] = meshgrid(x, z);
            Y = (d - a*X - c*Z) / b;
        case 1  % 解x
            y = linspace(point(2)-range, point(2)+range, num_points);
            z = linspace(point(3)-range, point(3)+range, num_points);
            [Y, Z] = meshgrid(y, z);
            X = (d - b*Y - c*Z) / a;
    end
    
    % 绘制平面
    surf(X, Y, Z, 'FaceAlpha', 0.5);
    %hold on;
    % 标出已知点
    plot3(point(1), point(2), point(3), 'ro', 'MarkerSize', 1, 'MarkerFaceColor', 'r');
    %hold off;
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    grid on;
    %title('平面绘制');
end