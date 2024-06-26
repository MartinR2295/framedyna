module FrexyBackInsert(
insert_width = 40,
insert_length = 80,
side_cube_width = 10,
side_cube_length = 5,
height=10,
base_height = 8
) {
    union() {
        cube([insert_width, insert_length, height]);
        translate([insert_width - side_cube_width, -side_cube_length, 0])
            cube([side_cube_width, side_cube_length, base_height]);
        translate([0, -side_cube_length, 0])
            cube([side_cube_width, side_cube_length, base_height]);
        translate([insert_width - side_cube_width, insert_length, 0])
            cube([side_cube_width, side_cube_length, base_height]);
        translate([0, insert_length, 0])
            cube([side_cube_width, side_cube_length, base_height]);
    }
}

FrexyBackInsert();