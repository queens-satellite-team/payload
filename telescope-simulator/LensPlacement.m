bench = Bench;

lens1 = Lens([ 40 0 0 ], 58, -40, -20, { 'air' 'bk7' });
bench.append(lens1);

screen = Screen( [40 0 0], 80, 80, 512, 512);
bench.append(screen);

nrays = 10;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'random' );
rays_through = bench.trace( rays_in );
bench.draw( rays_through, 'lines' );