%% Lab 3 Step 1 - Problem 1d: Angular Velocity vs Time
% Computes the body-frame angular velocity from consecutive rotation matrices:
%   w_hat(t_i)*theta(t_i) = log( R(t_i)' * R(t_{i+1}) )
%   w_b(t_i) ~= w(t_i)*theta(t_i) / (t_{i+1} - t_i),   i = 1..N-1
% The last sample is copied from the previous one: w_b(t_N) = w_b(t_{N-1}).

clear all;
close all;
clc;

% load csv data, convert angles from degrees to radians
M = readmatrix("mocap_data.csv");
N = size(M,1);

t = M(:,1);                  % time (s)
roll  = deg2rad(M(:,5));
pitch = deg2rad(M(:,6));
yaw   = deg2rad(M(:,7));

%% Convert rpy to rotation matrices (given in starter code)
R = zeros(3,3,N);
Rx = @(phi)   [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Ry = @(beta)  [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = @(alpha) [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];

for i = 1:N
    R(:,:,i) = Rz(yaw(i))*Ry(pitch(i))*Rx(roll(i));
end

%% Calculate body angular velocity
wb = zeros(N,3);             % row i holds w_b(t_i)' (rad/s)
for i = 1:N-1
    % relative rotation from t_i to t_{i+1}, expressed in the body frame
    dR = R(:,:,i)' * R(:,:,i+1);
    w_hat_theta = ECE569_MatrixLog3(dR);       % w_hat(t_i)*theta(t_i)
    w_theta = ECE569_so3ToVec(w_hat_theta);    % w(t_i)*theta(t_i)
    wb(i,:) = w_theta' / (t(i+1) - t(i));
end
wb(end,:) = wb(end-1,:);

%% Plot w_b1, w_b2, w_b3 in subplots
fig = figure('Name', 'Figure 1.5: Angular Velocity vs Time');

subplot(3,1,1);
plot(t, wb(:,1), 'LineWidth', 1.5); grid on;
ylabel('\omega^b_1 (rad/s)'); xlim([t(1) t(end)]);
title('Metafly Body Angular Velocity vs Time');

subplot(3,1,2);
plot(t, wb(:,2), 'LineWidth', 1.5); grid on;
ylabel('\omega^b_2 (rad/s)'); xlim([t(1) t(end)]);

subplot(3,1,3);
plot(t, wb(:,3), 'LineWidth', 1.5); grid on;
ylabel('\omega^b_3 (rad/s)'); xlim([t(1) t(end)]);
xlabel('Time (s)');

% save the figure for the report
exportgraphics(fig, 'Fig1_5_AngularVelocity.png', 'Resolution', 300);
