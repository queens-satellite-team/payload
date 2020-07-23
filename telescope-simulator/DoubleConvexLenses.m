% Double Convex Lens Telescope design
% Piper Steffen

clear;
close all;
bench = Bench;

% Constants
conicCoeff = 0;
frontSurface = {'air' 'bk7'};
backSurface = {'bk7' 'air'};

% Aperture
aper = Aperture( [1 0 0], [60, 80] );
bench.append(aper);

% Single lens (front + Back surface) 

% Lens 1 (subscript naught/_o)
pos1 = 10;          % Position
diam1 = 60;         % Diameter
spRad1 = 60;        % Spherical Radius
CT = 20;            % Center thickness
%Front
%lens1f = Lens([pos1 0 0], diam1, spRad1, conicCoeff, frontSurface);
lens1f = Lens( [30 0 0], 40, 40, 0, frontSurface);
% Flat Back
% lens1b = Lens([pos1+CT 0 0], diam1, 9999999999, conicCoeff, backSurface);
% Same back
%lens1b = Lens([pos1+CT 0 0], diam1, -spRad1, conicCoeff, backSurface);
lens1b = Lens([60 0 0], 40, -40, 0, backSurface);
bench.append({lens1f, lens1b});

% Screen
screen = Screen( [ 100 0 0 ], 60, 60, 512, 512 );
bench.append(screen);

% Determine focal distance
nrays = 500;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'random' );
fprintf( 'Tracing rays...\n' );
rays_through = bench.trace(rays_in);
fprintf('Trace successful. Drawing rays...\n');

npos = 50;
dv = zeros( npos, 1 );
scr_x = linspace( lens1b.r(1)+30, lens1b.r(1) + 60, npos );
for i = 1 : npos % loop over different screen distances
    screen.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through = bench.trace( rays_in ); % trace rays    
    [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
end

[ mdv, mi ] = min( dv ); % mdv=minimum value in dv, mi=index of minimum value
focal = scr_x( mi ); %focal is scr_x at the index where min dv occurs
fprintf( 'Back focal distance minimizing bundle std: %.3f\n', focal  - lens1b.r(1) );
fprintf( 'Bundle std: %.3f\n', mdv ); %mdv is the std

% reassign the screen distance so it occurs at the focal point
screen.r(1) = focal;

% draw bench elements 
bench.draw(rays_in);
bench.draw(rays_through, 'lines');
%figure('Name', 'Image on Screen');
%imshow(screen.image, []);

% display focusing
figure( 'Name', 'Optical system focusing', 'NumberTitle', 'Off' );
hold on;
plot( scr_x - lens1b.r(1), dv, '-*' );
plot( [40, 60], [mdv, mdv], '-');
xlabel( 'Screen distance from the back lens surface [mm]', 'FontSize', 12 );
ylabel( 'Bundle focus (standard deviation)', 'FontSize', 12 );

