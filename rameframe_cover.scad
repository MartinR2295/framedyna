$fn=50;
// Width of the image format
image_width = 100;
// Height of the image format
image_length = 150;
// Tolerance of the image (normally the print is a few mm bigger)
image_tolerance = 2;
// Height of the Frame (10, 20, 40, 80, etc.)
height=10;
// Height of the small image border on top of the base plate, to get a glas front between image and cover
image_border_height = 2.5;
// Strength of the border
cover_border_strength = 5;
// Strength of the Head (which borders the image)
cover_head_strength=2;
// Width of the Head (which borders the image)
cover_border_width = 5;
// Border Radius
border_radius = 5;
full_height = height+image_border_height+cover_head_strength;

// add 0 to some values, to hide it in the customizer UI
image_border_width = 2+0;

width=image_width+image_border_width*2+image_tolerance+cover_border_strength*2; // 106, 156
length=image_length+image_border_width*2+image_tolerance+cover_border_strength*2; // 156, 206,330
y_spacing = 8+0;
x_spacing = 8+0;

module RoundBorder(r,h) {
    translate([r,r,0]) difference() {
        translate([-r,-r,0]) cube([r,r,h]);
        cylinder(h=h, r=r);
    }
}

difference() {
    union() {
        // base
        union() {
            cube([width, cover_border_strength, full_height]);
            translate([0,length-cover_border_strength,0]) cube([width, cover_border_strength, full_height]);
            translate([0,0,0]) cube([cover_border_strength, length, full_height]);
            translate([width-cover_border_strength,0,0]) cube([cover_border_strength, length, full_height]);
        }

        // head
        translate([0,0,full_height-cover_head_strength]) union() {
            cube([width, cover_border_strength+cover_border_width, cover_head_strength]);
            translate([0,length-cover_border_strength-cover_border_width,0]) cube([width, cover_border_strength+cover_border_width, cover_head_strength]);
            translate([0,0,0]) cube([cover_border_strength+cover_border_width, length, cover_head_strength]);
            translate([width-cover_border_strength-cover_border_width,0,0]) cube([cover_border_strength+cover_border_width, length, cover_head_strength]);
        }
    }
    RoundBorder(r=border_radius, h=full_height);
    translate([0,length,0]) rotate([0,0,-90]) RoundBorder(r=border_radius, h=full_height);
    translate([width,length,0]) rotate([0,0,180]) RoundBorder(r=border_radius, h=full_height);
    translate([width,0,0]) rotate([0,0,90]) RoundBorder(r=border_radius, h=full_height);
}
