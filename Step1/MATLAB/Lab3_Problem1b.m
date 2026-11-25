%% Lab 3 Step 1 - Problem 1b: Velocity vs Time
% Approximates the Metafly origin's velocity in the fixed frame using a
% first-order difference over each timestep:
%   v(t_i) = (p(t_{i+1}) - p(t_i)) / (t_{i+1} - t_i),  i = 1..N-1
% There is no t_{N+1} sample, so we define v(t_N) = v(t_{N-1}).

clear all;
close all;
clc;

% load csv data
M = readmatrix("mocap_data.csv");
N = size(M,1);

t = M(:,1);        % time (s)
p = M(:,2:4);      % position [x y z] (m)

%% Calculate velocities numerically
v = zeros(N,3);    % row i holds v(t_i)'
for i = 1:N-1
    v(i,:) = (p(i+1,:) - p(i,:)) / (t(i+1) - t(i));
end
v(end,:) = v(end-1,:);

%% Plot x_dot, y_dot, z_dot in subplots
fig = figure('Name', 'Figure 1.2: Velocity vs Time');

subplot(3,1,1);
plot(t, v(:,1), 'LineWidth', 1.5); grid on;
ylabel('$\dot{x}$ (m/s)', 'Interpreter', 'latex'); xlim([t(1) t(end)]);
title('Metafly Velocity vs Time');

subplot(3,1,2);
plot(t, v(:,2), 'LineWidth', 1.5); grid on;
ylabel('$\dot{y}$ (m/s)', 'Interpreter', 'latex'); xlim([t(1) t(end)]);

subplot(3,1,3);
plot(t, v(:,3), 'LineWidth', 1.5); grid on;
ylabel('$\dot{z}$ (m/s)', 'Interpreter', 'latex'); xlim([t(1) t(end)]);
xlabel('Time (s)');

% save the figure for the report
exportgraphics(fig, 'Fig1_2_Velocity.png', 'Resolution', 300);
