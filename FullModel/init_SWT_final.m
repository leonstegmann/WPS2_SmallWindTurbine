%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Init Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aero model
load('WindprofilHOST.mat')
load('v3223.mat')
load('v_5h_1223.mat')
load('v_5h_30s_delay.mat')

%mechanical model
w_rot=(184/60)*2*pi;

%Terrain Model
z=12;%[m] Nacel Height
z_ref=12; %[m] Measurement Mast Height
alpha=0.19; %[] Hellmann Exponent

%TSR Calculation
A=19.76; %[m^2] Rotor Area
r_rot=sqrt(A/pi); %[m] Rotor Blase Lenght

%Rotor Torque
rho=1.225; %[kg/m^2] Air Density
%pu
P_rated=5000; %W
T_rated=P_rated/w_rot;

%% %Mechanical (DriveTrain)
gearbox_ratio = 8.27 ;                   % 1:Gearbox ratio

% Low Speed Shaft side
J_r = 142.99 ; % [kg*m^2] Inertia of the WTrotor

% High Speed Shaft side
J_g = 0.0491 ; % [kg*m^2] Inertia of the Generator

% 2-Mass equivalent model constants
K_eq = 16887; % [Nm/rad] Stiffness (torsional spring constant)
D_eq = 1500;  % [Nms/rad] Damping (frcition constant)

%% %Electrical (Generator) (rated = nominal)
fs = 50 ;                               % [Hz] stator (= grid) frequency
n_pp = 2;                               % Number of pole-pairs
P_nominal = 5.5e3 ;                     % [W] (Active MECHANICAL power)
V_nominal = 400 ;                       % [V] (line-to-line) (rms) % line voltage == phase-to-phase
nr = 1550 ;  %!!! Was changed!!!%       % [rpm] nominal rotor speed 
I_nominal = 10 ;                        % [A] (phase)
pf = 0.7 ;                              % (cos(phi))

P_out = V_nominal*I_nominal*pf*sqrt(3) ;% [W] (Active power) : sqrt(3) because current is L2N
P_in = P_nominal                       ; %[W] == P_mech
n_eff_gen  = P_out/P_in                ;% Efficiency Generator
w_r_rated = 2*pi*nr/60                 ;% [rad/s] rated speed Generator
T_mech = P_nominal/w_r_rated           ;% [Nm] nominal mechnaical Generator Torque 
ns = fs*60/n_pp ;                       % [rpm] stator speed 
s_rated = (ns - nr) / ns  ;             % rated slip

% some other interesting calculations
%S_nominal = V_nominal*I_nominal*sqrt(3) % [kVA] (Apparent power)
%Q_nominal = P_nominal*tan(acos(pf))     % [kVAR] (Reactive power)
%V_L2N = V_nominal/sqrt(3)               % [V] (line-to-neutral) (rms)
%V_peak_L2N = V_L2N*sqrt(2)              % [V] (peak)
%I_peak_L2N = P_nominal/(3 * V_peak_L2N) % [A] (peak)

%% Cabel Parameter based on a 185mm^2 cable and Matlab calculation model
RsRm=2.49; %Ohm
LsLm=3.75e-3; %H
Cp_half=0.8e-6; %F
Cg_half=36e-6; %F
Rlp2=74; %Ohm

%% Grid parameter
Lg=12e-3; %H
Rlp1=100; %Ohm
Rg=2 ;
Ug=400; %V

%Filter Capacitor
Cf=1e-6;
Load_at_POC = 1.5e3 ; % [W]

%% % Capacitor Sizing

pf = 0.75; % simluated from the machine
P = P_out ;                         
required_pf =  0.98 ;
phi_req = acos(required_pf);
phi  = acos(pf) ;                   % angle bewteen voltage current
phi_deg = rad2deg(phi) ;            % angle in deg ° in nominal 
phi_req_deg = rad2deg(phi_req) ;

% cut-in power
%P_cutin = 150*n_eff_gen;  
%Q_min = P_cutin*tan(acos(0.4)) ;
% cut-out in power
%Q_max = tan(acos(0.7))*P ;
%Q_95 = P*tan(acos(required_pf)) ;

% Reactive power compensation calculation
Q_tot = (tan(phi)-tan(phi_req))*P ;%*1e-3           % in [kVAR] comsumed reactive power at nominal
Q_comp_fixedC = round(0.99*Q_tot,-2);
Q_c = Q_tot/3 ;                     % 3 Capacitors for the 3 phases
X_c = V_nominal^2/Q_c ;             % Reactance
C_bank = 1/(2*pi*fs* X_c); %*1e6     %in [uF] Capacitance for each Capacitor

% Calculate real component
C_real =  round(C_bank,6) ;% 22e-6    ;     % a realistic capacitpr size that can be purchased
X_real =  1/(2*pi*fs* C_real);
Q_comp_real = 3* V_nominal^2/X_real ;

% USELESS

%Q_base = 0.1*Q_tot;
%Q_step = 0.225*Q_tot;
% Power factor Threshholds for Capacitor bank
%CapacitorBank_PF_tresholds = [0.7 0.8 0.9] ;  % pf threshholds for cap steps
%C_step_tresholds = [Q_base+0*Q_step Q_base+1*Q_step Q_base+2*Q_step Q_base+3*Q_step] % Q in KVAR
% Single Capacitance calculation
%Q_c = Q_tot/3 ;
%X_c = V_nominal^2/Q_c ;             % Reactance
%C_bank = 1/(2*pi*fs* X_c) %*1e6     %in [uF]
%C_base = 0.8*C_bank
%C_step = 0.05*C_base                % => C_base + 4 * C_step = C_bank


%% Base variables calculation

V_base = V_nominal;
P_G_base = 5.5e3 ;
w_s_base = 2*pi*50 ;
w_r_base = w_s_base/n_pp ;
P_T_base = 5.5e3;
w_T_base = w_r_base/gearbox_ratio 
T_T_base = P_T_base/w_T_base 
T_G_base = P_G_base/w_r_base ;

T_rated = n_eff_gen*5800/w_r_rated ;

%%
% Mechanical System Torque Tests
%T_min_LS = 0.0846 ;
%T_max_LS = 309,8 ; 
T_test  = 1 * T_T_base ;           % Test Torque Turbine    
Tg_test = 1 * T_G_base  ;          % Test Torque Generator
t_test = J_r*w_T_base/T_test      % time needed to accelerate Turbine to nomial speed with rated power
%w_acceleration_T = T_test/J_r
%w_acceleration_G = Tg_test/J_g

%% Generator Test 

w_start = w_r_base ;
w_stop1 = w_r_base + (w_r_rated-w_r_base)/2 ;
w_stop2 = w_r_rated ;

%% 
disp('  Initialisation Successful !!')


