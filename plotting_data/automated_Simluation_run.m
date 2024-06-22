%% Simulation Runs

modelFolder = 'C:\dev\matlab&simulink_projects\WPS2_SmallWindTurbine\FullModel\' ;
modelname = 'SWT_fullModel_v2_corrected.slx';
SimulationFolder = 'Simulation_runs\';
Simulation_Time = 329;

% Run 1 LOW LOAD
Load_at_POC = 1.5e3;
disp('Running Simluation 1 ...');
sim(append(modelFolder ,modelname),Simulation_Time) ;
disp('Simluation 1 DONE!');

out_comp_lowload = ans;
save(append(SimulationFolder ,'sim_comp_lowload.mat'),'out_comp_lowload');
disp('Saving DONE.');

% Run 2 HIGH LOAD
Load_at_POC = 5e3;

disp('Running Simluation 2 ...');
sim(append(modelFolder ,modelname),Simulation_Time) ;
disp('Simluation 2 DONE');
out_comp_highload = ans;
save(append(SimulationFolder ,'sim_comp_highload.mat'),'out_comp_highload');
disp('Saving DONE.');
