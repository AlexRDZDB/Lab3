%% Lab 3 Step 1 - Problem 1e: Distance Squared vs Time
% Computes the squared distance on SO(3) from each orientation R(t_i) to the
% desired orientation Rd = R(t_N) (the last sample), using the result
% proved in part 1:
%   d(R, Rd)^2 = 2*Tr(I - R'*Rd)

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

%% Calculate d^2 to the desired rotation Rd = R(t_N)
Rd = R(:,:,N);
d2 = zeros(N,1);
for i = 1:N
    d2(i) = 2*trace(eye(3) - R(:,:,i)'*Rd);
end

%% Plot d^2 over time
fig = figure('Name', 'Figure 1.6: Distance Squared vs Time');
plot(t, d2, 'LineWidth', 1.5); grid on;
xlim([t(1) t(end)]);
xlabel('Time (s)');
ylabel('d(R(t), R_d)^2 (unitless)');
title('Squared Distance to Desired Orientation R_d = R(t_N)');

% save the figure for the report
exportgraphics(fig, 'Fig1_6_DistanceSquared.png', 'Resolution', 300);
