% screen a theta by both theta threshold
%
% 2023-09-30, Yixuan Li
%

function is_passed = screen_a_theta(theta,theta_pre,theta_next)

    theta_threshold = 20; % deg
    theta_threshold = theta_threshold/180*pi;
    try
        if my_diff_abs(theta,theta_pre) < theta_threshold || my_diff_abs(theta,theta_next) < theta_threshold
            is_passed = 1;
        else
            is_passed = 0;
        end
    catch
        why;
    end
    
end