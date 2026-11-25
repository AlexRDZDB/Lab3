%% Lab 3 Step 1 - Problem 1c: Orientation vs Time
% Converts each roll-pitch-yaw sample into a rotation matrix R(t_i), then
% computes its exponential coordinates (w(t_i), theta(t_i)) with
%   R -> MatrixLog3 -> so3ToVec -> AxisAng3
% and plots w1(t), w2(t), w3(t), theta(t) in four subplots.

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

%% Exponential coordinates: R(t_i) = e^(w_hat * theta)
w = zeros(N,3);              % row i holds w(t_i)' (unit vector)
theta = zeros(N,1);          % theta(t_i) in rad
for i = 1:N
    Ri = R(:,:,i);
    w_hat_theta = ECE569_MatrixLog3(Ri);           % 3x3 skew-symmetric
    w_theta = ECE569_so3ToVec(w_hat_theta);        % 3-vector w*theta
    [wi, theta(i)] = ECE569_AxisAng3(w_theta);     % split into (w, theta)
    w(i,:) = wi';
end

%% Plot w1, w2, w3, theta in subplots
fig = figure('Name', 'Figure 1.4: Orientation vs Time');

subplot(4,1,1);
plot(t, w(:,1), 'LineWidth', 1.5); grid on;
ylabel('\omega_1 (unitless)'); xlim([t(1) t(end)]);
title('Metafly Orientation (Exponential Coordinates) vs Time');

subplot(4,1,2);
plot(t, w(:,2), 'LineWidth', 1.5); grid on;
ylabel('\omega_2 (unitless)'); xlim([t(1) t(end)]);

subplot(4,1,3);
plot(t, w(:,3), 'LineWidth', 1.5); grid on;
ylabel('\omega_3 (unitless)'); xlim([t(1) t(end)]);

subplot(4,1,4);
plot(t, theta, 'LineWidth', 1.5); grid on;
ylabel('\theta (rad)'); xlim([t(1) t(end)]);
xlabel('Time (s)');

% save the figure for the report
exportgraphics(fig, 'Fig1_4_Orientation.png', 'Resolution', 300);
