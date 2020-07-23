function telescopeModel () 
% Attempt to model the mak telescope using the optometrika library
% Author: Piper Steffen

% close any existing figures
close all;

% create bench class
bench = Bench;

% Add optical elements in order they are encountered by light

% Aperture
% Unknown: What units are all these parameters in??
pos = [-13, 0, 0];
diam = [60, 120]; % The aperature diameter given in the manual is 60 mm
aper = Aperture( pos, diam );
bench.append(aper);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Test lens - altered parameters from example 1
% % Makes a fun pattern with a lot going on, nothing useful, but play around
% % with to understand how the parameters effect the sim
% % front lens surface
% lens1 = Lens( [ 40 0 0 ], 20, 40, -1, { 'air' 'bk7' } ); % parabolic surface
% % back lens surface
% lens2 = Lens( [ 60 0 0 ], 58, -30, -3, { 'bk7' 'air' } ); % concave hyperbolic surface
% bench.append( { lens1, lens2 } );
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following elements are named as specified in figure 186 of this
% webpage: https://www.telescope-optics.net/maksutov_cassegrain_telescope.htm
% Refer to it for all details on maksutov-caseegrain telescopes.

% Corrector Lens
% Front lens surface
pos = [0,0,0];
diam = 60;
spRad = -70;
conicCoeff = 0;
glass = { 'air' 'bk7' };
lens1 = Lens( pos, diam, spRad, conicCoeff, glass);

% Back lens surface
pos = [5, 0, 0];
diam = 60;
spRad = -70;
conicCoeff = 0;
glass = { 'bk7' 'air' };
lens2 = Lens( pos, diam, spRad, conicCoeff, glass);

bench.append( {lens1, lens2} );

% % back surface of secondary mirror
% pos = [35 0 0];
% diam = 15;
% spRad = -80;
% conicCoeff = 0;
% glass = { 'mirror' 'air'};
% mirror1 = Lens ( pos, diam, spRad, conicCoeff, glass );
% bench.append(mirror1);

% Primary Mirror - parabolic
pos = [ 90, 0, 0 ];
%diam = [20 60];
diam = 60;
spRad = -300;
conicCoeff = 0;
glass = { 'air' 'mirror'};
mirror2 = Lens( pos, diam, spRad, conicCoeff, glass );
bench.append(mirror2);

% front surface of the secondary mirror
pos = [ 5 0 0];
diam = 15;
spRad = 800;
conicCoeff = 0;
glass = { 'mirror' 'air'};
mirror3 = Lens( pos, diam, spRad, conicCoeff, glass);
bench.append(mirror3);

% Screen - in place of the camera/sensor
% Parameters to Screen( ) are defined as...
pos = [106,0,0];
w = 60;
h = 60; 
wbins = 512; % The time to run depends heavily on how big these are!!
hbins = 512;

screen = Screen( pos, w, h, wbins, hbins);
bench.append(screen);

% create collimated rays
nrays = 50;
geometry = 'collimated';
origin  = [ -100 0 0 ];
dir = [1 0 0];
diam = 80;
pattern = 'hexagonal';
rays_in = Rays( nrays, geometry, origin, dir, diam, pattern );

fprintf( 'Tracing rays...\n' );
rays_through = bench.trace( rays_in, 0 ); % the second parameter set to 0 enables ray tracing for rays missing some elements on the bench

% draw bench elements and draw rays as arrows
bench.draw( rays_through, 'lines', [], [] ); 

% get the screen image in high resolution
nrays = 100;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );
bench.trace( rays_in, 0 );
figure( 'Name', 'Image on the screen', 'NumberTitle', 'Off' );
imshow( screen.image, [] );

end 