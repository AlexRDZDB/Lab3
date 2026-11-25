%% Lab 3 Step 1 - Problem 1a: Position vs Time
% Reads the Metafly mocap data and plots x(t), y(t), z(t) in three subplots.

clear all;
close all;
clc;

% load csv data (header row is skipped automatically by readmatrix)
M = readmatrix("mocap_data.csv");

t = M(:,1);   % time (s)
x = M(:,2);   % position x (m)
y = M(:,3);   % position y (m)
z = M(:,4);   % position z (m)

%% Problem 1a: plot x, y, z data in subplots
fig = figure('Name', 'Figure 1.1: Position vs Time');

subplot(3,1,1);
plot(t, x, 'LineWidth', 1.5); grid on;
ylabel('x (m)'); xlim([t(1) t(end)]);
title('Metafly Position vs Time');

subplot(3,1,2);
plot(t, y, 'LineWidth', 1.5); grid on;
ylabel('y (m)'); xlim([t(1) t(end)]);

subplot(3,1,3);
plot(t, z, 'LineWidth', 1.5); grid on;
ylabel('z (m)'); xlim([t(1) t(end)]);
xlabel('Time (s)');

% save the figure for the report
exportgraphics(fig, 'Fig1_1_Position.png', 'Resolution', 300);
