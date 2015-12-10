# flow_deformation

- problem_b4.m
    The program that satisfies problem B4 (part 2) in project 4. The script
    launches a simulation of a a 3D cube moving through space. The path in red
    actually corresponds to real odometry measurements from a quadrotor. The path
    acheived by the cube is computed by sampling a small portion of the quadrotor
    trajectory in time and computing a cubic b-spline interpolation through the set
    of points.

    Parameters:
        cond - end condition for the interpolation
        N - number of subdivisions for the bezier curve
        feq - the frequency at which to sample the quadrotor path

- deforminterp.m
    The program that satisfies problem B4 (part 1) in project 4. Running 
    test_interp.m launches a small illustrative example of its use.

- sologm.m
    The program that satisfies problem B3 in project 4.

NOTE: Changing the locations of the data/ files must be followed by changes
    to the path names in load_quad_data.
