%% Physical constants
GM = 3.986004418e14; % Standard Gravitational parameter of Earth (m^3/s^2)
earth_r = 6378.1e3; % m
G_sc = 1.361e3; % Solar constant flux density (W/m^2)

%% Satellite parameters
orbit_r = 400.0e3; % m
angular_x = 0.01; %arcsecond/sec
orbit_speed = sqrt(GM/(orbit_r+earth_r)); %m/s

%% Camera specifications
sensor_size = [4.8, 3.6]; %[11.3e-3, 7.1e-3]; % m
focal_length = 50.0e-3; % m
shutter_speed = 1e-3; % s
colour_mode = 0;
resolution = [1936, 1216];
downlink_budget = 108e3*8; % bits per pass

