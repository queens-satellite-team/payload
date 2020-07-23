% Author: Piper Steffen
% 2019-11-03
% Attempt to design a custom lens with approximately a 50 mm focal length
% For use with the ZWO ASI174 MM/MC sensor

close all;
bench = Bench;

% Add elements in the order they are encountered by light

aper = Aperture( [1 0 0], [25 40]);
bench.append(aper);

pos = [10 0 0];
diam = 25;
spRad = 25.84;
conicCoeff = 0;
glass = {'air' 'bk7'};
lens1 = Lens(pos, diam, spRad, conicCoeff, glass);
lens2 = Lens([14.7 0 0], diam, 100000000, conicCoeff, {'bk7' 'air'});
bench.append(lens1);
bench.append(lens2);

% screen
screen = Screen( [ 58 0 0 ], 25, 25, 512, 512 );
bench.append(screen);

nrays = 500;
%rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'random' );
fprintf( 'Tracing rays...\n' );
rays_through = bench.trace(rays_in);
fprintf('Trace successful. Drawing rays...\n');

% draw bench elements 
%bench.draw(rays_in);
%bench.draw(rays_through, 'lines');
%figure('Name', 'Image on Screen for first configuration');
%imshow(screen.image, []);

npos = 50;
dv = zeros( npos, 1 );
scr_x = linspace( lens2.r(1) + 40, lens2.r(1) + 60, npos );
for i = 1 : npos % loop over different screen distances
    screen.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through = bench.trace( rays_in ); % trace rays    
    [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
end

[ mdv, mi ] = min( dv ); % mdv=minimum value in dv, mi=index of minimum value
focal = scr_x( mi ); %focal is scr_x at the index where min dv occurs
fprintf( 'Back focal distance minimizing bundle std: %.3f\n', focal  - lens2.r(1) );
fprintf( 'Bundle std: %.3f\n', mdv ); %mdv is the std

% reassign the screen distance so it occurs at the focal point
screen.r(1) = focal;

% draw bench elements 
bench.draw(rays_in);
bench.draw(rays_through, 'lines');
figure('Name', 'Image on Screen for first configuration');
%imshow(screen.image, []);

%find the tightest focus position
f = rays_through( end - 1 ).focal_point;
fprintf( 'Back focal distance based on convergence: %.3f\n', f(1)  - lens2.r(1) );

% display focusing
figure( 'Name', 'Optical system focusing', 'NumberTitle', 'Off' );
hold on;
plot( scr_x - lens2.r(1), dv, '-*' );
plot( [40, 60], [mdv, mdv], '-');
xlabel( 'Screen distance from the back lens surface [mm]', 'FontSize', 12 );
ylabel( 'Bundle focus (standard deviation)', 'FontSize', 12 );

