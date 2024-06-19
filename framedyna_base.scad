// Width of the image format
image_width = 550;
// Height of the image format
image_length = 200;
// Tolerance of the image (normally the print is a few mm bigger)
image_tolerance = 2;
// Printing Tolerance (use 0.1 to 0.2mm)
tolerance = 0.2;
// Height of the Frame (10, 20, 40, 80, etc.)
height=10;
// Height of the small image border on top of the base plate, to get a glas front between image and cover
image_border_height = 2.5;

// add 0 to some values, to hide it in the customizer UI
image_border_width = 2+0;
width=image_width+image_border_width*2+image_tolerance; // 106, 156
length=image_length+image_border_width*2+image_tolerance; // 156, 206,330
toleranced_width = width - tolerance*2;
toleranced_length = length - tolerance*2;
base_height = 8+tolerance;
y_spacing = 8+0;
x_spacing = 8+0;

// FrexyBackInsert
insert_width = 40+0;
insert_length = 80+0;
side_cube_width = 10+0;
side_cube_length = 5+0;
insert_side_width = 10+0;
insert_side_length = 5+0;
insert_side_offset = 10+0;
side_cube_insert_side_width = 2+0;
side_cube_insert_side_length = 2+0;
toleranced_insert_width = insert_width + tolerance * 2;
toleranced_insert_length = insert_length + tolerance * 2;
toleranced_side_cube_width = side_cube_width + tolerance * 2;
toleranced_side_cube_length = side_cube_length + tolerance;
toleranced_insert_side_width = insert_side_width + tolerance*2;
toleranced_insert_side_length = insert_side_length + tolerance*2;
toleranced_side_cube_insert_side_width = side_cube_insert_side_width + tolerance;
toleranced_side_cube_insert_side_length = side_cube_insert_side_length + tolerance*2;

module FrexyBackInsert(
insert_width = 40,
insert_length = 80,
side_cube_width = 10,
side_cube_length = 5,
height=10,
base_height = 8.2
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

module FrexySideInsert(
width=10,
length=5,
height=8.2,
side_cube_width=2,
side_cube_length=2
) {
    translate([side_cube_width,0,0]) union() {
        cube([width,length,height]);
        translate([-side_cube_width,length/2-side_cube_length/2,0]) cube([side_cube_width,side_cube_length,height]);
        translate([width,length/2-side_cube_length/2,0]) cube([side_cube_width,side_cube_length,height]);
    }
}

x_mid = ((toleranced_width/2)+(toleranced_insert_length/2));
y_mid = ((toleranced_length/2)-(toleranced_insert_width/2));

real_y_amount = floor((toleranced_length-y_spacing)/(toleranced_insert_width+y_spacing));
real_x_amount = floor((toleranced_width-x_spacing)/(toleranced_insert_length+x_spacing));
// don't use real_y_amount, because we only want an uneven number, to have one insert always in the middle
y_amount = (real_y_amount % 2 == 0) ? real_y_amount - 1 : real_y_amount;
x_amount = (real_x_amount % 2 == 0) ? real_x_amount - 1 : real_x_amount;
echo("x amount", x_amount);
echo("y_amount", y_amount);

y_gap = (y_amount < 2) ? 0 :(toleranced_length-y_spacing*2-toleranced_insert_width*y_amount)/(y_amount-1);
x_gap = (x_amount < 2) ? 0 :(toleranced_width-x_spacing*2-toleranced_insert_length*x_amount)/(x_amount-1);
echo("x_gap", x_gap);
echo("y_gap", y_gap);
difference() {
    union() {
        // base element
        cube([toleranced_width,toleranced_length, height]);

        // image_border
        translate([0, 0, height]) cube([image_border_width,toleranced_length, image_border_height]);
        translate([toleranced_width-image_border_width, 0, height]) cube([image_border_width,toleranced_length, image_border_height]);
        translate([0, 0, height]) cube([toleranced_width, image_border_width, image_border_height]);
        translate([0, toleranced_length-image_border_width, height]) cube([toleranced_width, image_border_width, image_border_height]);
    }
    // inserts
    for (j = [0:1:x_amount-1]) {
        half_j = floor(j/2);
        for (i = [0:1:y_amount-1]) {
            half_i = floor(i/2);
            y_offset = (i == 0) ? y_mid : y_mid + ((i % 2 == 0) ? -(i-half_i):i-half_i)*(toleranced_insert_width + y_gap);
            x_offset = (j == 0) ? -x_mid : -x_mid + ((j % 2 == 0) ? -(j-half_j):j-half_j)*(toleranced_insert_length + x_gap);
            rotate([0,0,90]) translate([
                y_offset,
                x_offset,
                0
                ]) FrexyBackInsert(
            insert_width=toleranced_insert_width,
            insert_length=toleranced_insert_length,
            side_cube_width=toleranced_side_cube_width,
            side_cube_length=toleranced_side_cube_length,
            height=height,
            base_height=base_height
            );
        }
        // insert spacings
        y_insert_spacing = y_gap - y_spacing*2;
        if (y_insert_spacing > 5) {
            y_insert_spacing_mid = y_mid-y_spacing;
            for (i = [-1:1:y_amount-1-1]) {//y_amount-1-1
                x_offset = ((j == 0) ? x_mid : x_mid + ((j % 2 == 0) ? -(j-half_j):j-half_j)*(toleranced_insert_length + x_gap))-toleranced_insert_length;
                half_i = floor(i/2);
                min_plus_multiplicator = ((i == -1) ? 0 : (i % 2 == 0) ? -(i-half_i+1):i-half_i);
                current_offset = (toleranced_insert_width+y_spacing*2+y_insert_spacing) * ((i == 1) ? 1 : min_plus_multiplicator);
                echo(current_offset);
                current_y_insert_spacing_mid = y_insert_spacing_mid+current_offset;
                translate([x_offset,
                    current_y_insert_spacing_mid,
                    0])
                    rotate([0,0,-90])
                        cube([y_insert_spacing, toleranced_insert_length, height]);
            }
        }
    }

    // x spacing
    union() {
        x_insert_spacing = x_gap - x_spacing*2;
        if (x_insert_spacing > 5) {
            x_insert_spacing_mid = x_mid-y_spacing;
            for (i = [1:1:x_amount-1]) {
                current_width = 20;
                start_offset =
                            toleranced_insert_length+x_spacing+x_gap/2-current_width/2;
                current_offset = start_offset + (toleranced_insert_length+x_gap)*(i-1);

                translate([current_offset, y_spacing, 0]) cube([current_width, length-y_spacing*2, height]);
            }
        }
    }

    // side inserts
    rotate([0,0,90]) translate([insert_side_offset-side_cube_insert_side_width,-insert_side_length,0]) FrexySideInsert(
    width=toleranced_insert_side_width, length=toleranced_insert_side_length, height=base_height,
    side_cube_width=toleranced_side_cube_insert_side_width,
    side_cube_length=toleranced_side_cube_insert_side_length);
    rotate([0,0,90]) translate([toleranced_length-insert_side_offset-insert_side_width-side_cube_insert_side_width,-insert_side_length,0]) FrexySideInsert(
    width=toleranced_insert_side_width, length=toleranced_insert_side_length, height=base_height,
    side_cube_width=toleranced_side_cube_insert_side_width,
    side_cube_length=toleranced_side_cube_insert_side_length);

    rotate([0,0,90]) translate([insert_side_offset-side_cube_insert_side_width,-toleranced_width,0]) FrexySideInsert(
    width=toleranced_insert_side_width, length=toleranced_insert_side_length, height=base_height,
    side_cube_width=toleranced_side_cube_insert_side_width,
    side_cube_length=toleranced_side_cube_insert_side_length);
    rotate([0,0,90]) translate([toleranced_length-insert_side_offset-insert_side_width-side_cube_insert_side_width,-toleranced_width,0]) FrexySideInsert(
    width=toleranced_insert_side_width, length=toleranced_insert_side_length, height=base_height,
    side_cube_width=toleranced_side_cube_insert_side_width,
    side_cube_length=toleranced_side_cube_insert_side_length);
}
