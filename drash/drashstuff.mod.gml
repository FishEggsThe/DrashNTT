// this gml is literally only here so that the beacon can produce light
#define step
	draw_dark();
	draw_dark_end();

/*#define draw
	with(CustomObject)
		draw_circle(x, y, 100, false);
*/
#define draw_dark // Light
    draw_set_color($808080);
    with(CustomObject) // instances_matching(CustomObject, "beacon", true)
		draw_circle(x, y, 180 + random(3), false);

#define draw_dark_end // Light outline
    draw_set_color($000000);
    with(CustomObject)
		draw_circle(x, y, 90 + random(3), false);