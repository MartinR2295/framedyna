module FrexySideInsert(
width=10,
length=5,
height=8,
side_cube_width=2,
side_cube_length=2
) {
    translate([side_cube_width,0,0]) union() {
        cube([width,length,height]);
        translate([-side_cube_width,length/2-side_cube_length/2,0]) cube([side_cube_width,side_cube_length,height]);
        translate([width,length/2-side_cube_length/2,0]) cube([side_cube_width,side_cube_length,height]);
    }
}

FrexySideInsert();