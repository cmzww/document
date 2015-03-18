% Abdel-Razzak Merheb
% SIMULINK Quadrotor simulation using Bouabdallah's system
% The controller used here is a PD controller
% Values of gains resembles those used by Mr. Bouabdallah
% 29/11/2012
% % % % % % % % % % % % % % %
clc
clear all
close all

global Jr Ix Iy Iz b d l m g Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps ZdF PhidF ThetadF PsidF ztime phitime thetatime psitime Zinit Phiinit Thetainit Psiinit Uone Utwo Uthree Ufour Ez Ep Et Eps

% global Jr Ix Iy Iz b d l m g;

% of the PD controller

kpp = 0.8; % PD controller :phi Roll angle Kp gain 
kdp = 0.4; % PD controller :phi Roll angle Kd gain 

kpt = 1.2; % PD controller :theta Pitch angle Kp gain 
kdt = 0.4; % PD controller :theta Pitch angle Kd gain 

kpps = 1;   % PD controller :psi Yaw angle Kp gain 
kdps = 0.4; % PD controller :psi Yaw angle Kd gain 

kpz = 100; % PD controller :z Height Kp gain 
kdz = 20;  % PD controller :z Height Kp gain 
Gains = [kpp kdp kpt kdt kpps kdps kpz kdz];
disp(Gains);
% Quadrotor constants
Ix = 7.5*10^(-3);  % Quadrotor moment of inertia around X axis
Iy = 7.5*10^(-3);  % Quadrotor moment of inertia around Y axis
Iz = 1.3*10^(-2);  % Quadrotor moment of inertia around Z axis
Jr = 6.5*10^(-5);  % Total rotational moment of inertia around the propeller axis
b = 3.13*10^(-5);  % Thrust factor
d = 7.5*10^(-7);  % Drag factor
l = 0.23;  % Distance to the center of the Quadrotor
m = 0.65;  % Mass of the Quadrotor in Kg
g = 9.81;   % Gravitational acceleration

% % Controlling the Quadrotor
% sim('PDQuadrotor')