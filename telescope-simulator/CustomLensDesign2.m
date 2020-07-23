% Author: Piper Steffen
% 2019-11-03
% Attempt to design a custom lens with approximately a 50 mm focal length
% For use with the ZWO ASI174 MM/MC sensor

% Add second lens (eyepeice) to focus

clear;
close all;
bench1 = Bench;
bench2 = Bench;
bench3 = Bench;

aper = Aperture( [1 0 0], [70 80]);
bench1.append(aper);
aper2 = Aperture( [1 0 0], [20 40]);
bench2.append(aper2);
bench3.append(aper);

% Constants
conicCoeff = 0;
frontSurface = {'air' 'bk7'};
backSurface = {'bk7' 'air'};

% LENS 1 - double convex
pos1 = 10;
diam1 = 63;
spRad1 = 61.39;
CT = 20.4;
lens1f = Lens([pos1 0 0], diam1, spRad1, conicCoeff, frontSurface);
lens1b = Lens([pos1+CT 0 0], diam1, -spRad1, conicCoeff, backSurface);
bench1.append({lens1f, lens1b}); % To find focal distance 1

% screen - arbitrary position, will update later
Fscreen1 = Screen( [ 50 0 0 ], 25, 25, 512, 512 );
bench1.append(Fscreen1);
n = 50; % number of distances to try
dv = zeros( n, 1 ); % array of zeros

% Range of distance to try focusing - 40 mm from back of lens 1 to 60 cm
% from back of lens2
scr_x1 = linspace( pos1+CT+40, pos1+CT+60, n );
nrays = 50;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );

% loop over different screen distances
for i = 1 : n 
    Fscreen1.r(1) = scr_x1( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through = bench1.trace( rays_in ); % trace rays    
    [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
end
[ mdv1, mi1 ] = min( dv ); % mdv=minimum value in dv, mi=index of minimum value

focal_1 = scr_x1( mi1 ); %focal_1 is scr_x at the index where min dv occurs
fprintf( 'Lens 1 focal x coordinate minimizing bundle std: %.3f\n', focal_1 );
fprintf( 'First Bundle std: %.3f\n', mdv1 ); %mdv1 is the std for lens 1

% reassign the screen distance so it occurs at the focal point
Fscreen1.r(1) = focal_1;

% plot the configuration - lens 1 with focal distance screen - from bench 1
% nrays = 50;
% rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );
%fprintf( 'Tracing rays...\n' );
%rays_through = bench1.trace(rays_in);
%fprintf('Trace successful. Drawing rays...\n');
%bench1.draw(rays_in);
%bench1.draw(rays_through, 'lines');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bench 2 - find focal distance of lens 2 
rays_in2 = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );

diam2 = 15;
spRad2 = 16.78;
CT = 1.5;
pos2 = 40; % arbitrary for now
lens2f = Lens([pos2 0 0], diam2, -spRad2, conicCoeff, frontSurface);
lens2b = Lens([pos2+CT 0 0], diam2, spRad2, conicCoeff, backSurface);
bench2.append({lens2f, lens2b});

% arbitrary for now
Fscreen2 = Screen( [ pos2+20 0 0 ], 100, 100, 512, 512 );
bench2.append(Fscreen2);

% FIND FOCAL DISTANCE OF LENS2 - CAN'T USE SAME METHOD AS FOR LENS 1 
% Need to scrap this and find a way to find focal_2....

% ????????

dv = zeros( n, 1 ); % array of zeros
% Range of distance to try focusing
scr_x = linspace( pos2+20, pos2+50, n );

% loop over different screen distances
for i = 1 : n 
    Fscreen2.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through2 = bench2.trace( rays_in2 ); % trace rays    
    [ ~, dv( i ) ] = rays_through2( end ).stat; % get stats on the last ray bundle
end
[ mdv2, ma2 ] = max( dv ); % mdv=minimum value in dv, mi=index of minimum value

focal_2 = scr_x( ma2 ); %focal_1 is scr_x at the index where min dv occurs
fprintf( 'Lens 2 focal x coordinate minimizing bundle std: %.3f\n', focal_2 - pos2);
fprintf( 'Second Bundle std: %.3f\n', mdv2 ); %mdv is the std

Fscreen2.r(1) = focal_2;
lens2f = Lens([pos2 0 0], diam2, -spRad2, conicCoeff, frontSurface);
lens2b = Lens([pos2+CT 0 0], diam2, spRad2, conicCoeff, backSurface);
bench2.append({lens2f, lens2b});

fprintf( 'Tracing rays...\n' );
rays_through2 = bench2.trace(rays_in2);
fprintf('Trace successful. Drawing rays...\n');
bench2.draw(rays_in2);
bench2.draw(rays_through2, 'lines');
