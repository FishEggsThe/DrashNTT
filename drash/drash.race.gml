// There's a lot of trace's here for debug lol
 // On Mod Load:
#define init
	global.newLevel = instance_exists(GenCont);

	global.name[0] = "DRASH";
	global.name[1] = "DISH";
	global.loadout[0] = "Drash#By Ian Boni";
	global.loadout[1] = "Dish#By Me";
	
	/// Define Sprites : sprite_add("path/to/sprite/starting/from/mod/location.png", frames, x-offset, y-offset) \\\
	 // A-Skin:
	global.spr_idle[0] = sprite_add("drash/drashidle.png",	4, 12, 12);
	global.spr_walk[0] = sprite_add("drash/drashwalk.png",	8, 12, 12);
	global.spr_hurt[0] = sprite_add("drash/drashhurt.png",	3, 12, 12);
	global.spr_dead[0] = sprite_add("drash/drashdead.png",	6, 12, 12);
	global.spr_sit1[0] = sprite_add("drash/drashsit1.png",	3, 12, 12);
	global.spr_sit2[0] = sprite_add("drash/drashsit2.png",	1, 12, 12);

	 // B-Skin:
	global.spr_idle[1] = sprite_add("dish/dishidle.png",	4, 12, 12);
	global.spr_walk[1] = sprite_add("dish/dishwalk.png",	4, 12, 12);
	global.spr_hurt[1] = sprite_add("dish/dishhurt.png",	3, 12, 12);
	global.spr_dead[1] = sprite_add("dish/dishdead.png",	3, 12, 12);
	global.spr_sit1[1] = sprite_add("dish/dishsit1.png",	3, 12, 12);
	global.spr_sit2[1] = sprite_add("dish/dishsit2.png",	1, 12, 12);
	
	 // Extra Sprites ohoho
	global.spr_shield = sprite_add("drash/drashshield.png",	8, 12, 12);
	global.spr_shieldcracked = sprite_add("drash/drashshieldcracked.png",	8, 12, 12);
	global.spr_combostrike = sprite_add("drash/drashcombostrike.png",	9, 24, 24);
	global.spr_beaconspawn = sprite_add("drash/drashbeaconspawn.png",	17, 30, 65);
	global.spr_beacon = sprite_add("drash/drashbeacon.png",	18, 30, 65);
	global.spr_beaconaura = sprite_add("drash/drashaura.png", 36, 40, 40);
	global.spr_beaconblast = sprite_add("drash/drashbeaconblast.png",	7, 15, 17);
	
	// I'm a fraud
	global.ms_mask = sprite_add("mask.png", 1, 7, 7);
	global.ms_nomask = sprite_add("nomask.png", 1, 3000, 3000);
	
	 // Character Selection / Loading Screen:
	global.spr_slct = sprite_add("drash/drashselect.png",	1,				0,  0);
	global.spr_port = sprite_add("drashportraits.png",	race_skins(),	40, 243);
	global.spr_skin = sprite_add("drashloadouts.png",	race_skins(),	16, 16);
	global.spr_icon = sprite_add("drashicons.png",		race_skins(),	10, 10);

	 // Ultras:
	global.spr_ult_slct = sprite_add("drash/drashultras.png",	ultra_count("drash"), 12, 16);
	global.spr_ult_icon[1] = sprite_add("drash/drashultrahuda.png", 1, 8, 9);
	global.spr_ult_icon[2] = sprite_add("drash/drashultrahudb.png", 1, 8, 9);


	var _race = [];
	for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
	while(true){
		/// Character Selection Sound:
		for(var i = 0; i < maxp; i++){
			var r = player_get_race(i);
			if(_race[i] != r && r = "drash"){
				sound_play(sndMutant10Slct); // Select Sound
			}
			_race[i] = r;
		}

		/// Call level_start At The Start Of Every Level:
		if(instance_exists(GenCont)) global.newLevel = 1;
		else if(global.newLevel){
			global.newLevel = 0;
			level_start();
		}
		wait 1;
	}


 // On Level Start:
#define level_start
	global.notChecked = true;
	global.deployOnce = true;
	global.canShield = true;
	global.upAndRunning = false;

 // On Run Start:
#define game_start
	sound_play(sndMutant10Cnfm); // Play Confirm Sound

#define race_soundbank
	return 10; // Rebel
 // On Character's Creation (Starting a run, getting revived in co-op, etc.):
#define create
	
	// Jumping-related variables
	distance = 0;
	airbourne = false; // rollTime is dead
	combo = 0;
	//reg_mask = global.ms_mask;
	reg_mask = mask_index;
	no_mask = global.ms_nomask;
	mask_index = reg_mask;
	v = -7;
	z_vel = v;
	z_grav = 1;
	y_original = y;
	f = 10;
	flip = 0;
	// If youre confused about the thing down here I think it's for direction
	l = 0;
	
	// For stomping
	canStomp = false;
	depthOriginal = depth;
	allClear = false;
	
	// Shield-related variables
	current_health = my_health;
	dfs = 6;
	damageForShield = dfs;
	tbd = 30;
	timeBetweenDamage = 0;
	st = 90;
	shieldTime = 0;
	notCreated = false;
	destroyShield = true;
	global.canShield = true;
	global.upAndRunning = false;
	
	// Ultra B stuff
	enemiesLeft = 0;
	global.notChecked = false;
	global.deployOnce = true;
	enemyX = 0;
	enemyY = 0;
	// Might implement these later
	//tout = 30; 
	//timeOut = 0;
	
	// Just for testing lol
	shakeForThatMuch = 0;
	

	 // Set Sprites:
	spr_idle = global.spr_idle[bskin];
	spr_walk = global.spr_walk[bskin];
	spr_hurt = global.spr_hurt[bskin];
	spr_dead = global.spr_dead[bskin];
	spr_sit1 = global.spr_sit1[bskin];
	spr_sit2 = global.spr_sit2[bskin];
/*
	 // Set Sounds:
	snd_wrld = sndMutant10Wrld;	// FLÄSHYN
	snd_hurt = sndMutant10Hurt;	// THE WIND HURTS
	snd_dead = sndMutant10Dead;	// THE STRUGGLE CONTINUES
	snd_lowa = sndMutant10LowA;	// ALWAYS KEEP ONE EYE ON YOUR AMMO
	snd_lowh = sndMutant10LowH;	// THIS ISN'T GOING TO END WELL
	snd_chst = sndMutant10Chst;	// TRY NOT OPENING WEAPON CHESTS
	snd_valt = sndMutant10Valt;	// AWWW YES
	snd_crwn = sndMutant10Crwn;	// CROWNS ARE LOYAL
	snd_spch = sndMutant10Spch;	// YOU REACHED THE NUCLEAR THRONE
	snd_idpd = sndMutant10IDPD;	// BEYOND THE PORTAL
	snd_cptn = sndMutant10Cptn;	// THE STRUGGLE IS OVER
*/
	 // the player being referred to
	//global.playerIndex = index;
	
 // Every Frame While Character Exists:
#define step
	//trace(string(sprite_get_width(mask_index) * image_xscale));
	/*with(enemy){
		hspeed = 0;
		vspeed = 0;
	}*/
	
	if(sprite_index == spr_walk){
		//image_speed = 0.133;
	}

	//Giving enemies and props variables
	with(enemy){ if "stompTime" not in self { stompTime = 0 } }
	with(enemy){ if "staggered" not in self { staggered = 0 } }
	with(enemy){ if "checked" not in self { checked = false } }
	with(prop){ if "stompTimeProp" not in self { stompTimeProp = false } }
	
	// Ultra B: Kindred Contact
	if(ultra_get("drash", 2)){
		if(global.notChecked && enemiesLeft <= 0){
			with(enemy) {
				checked = true;
				other.enemiesLeft += kills;
			}
			
			//trace("Total: " + string(enemiesLeft));
			enemiesLeft /= 2;
			enemiesLeft = floor(enemiesLeft);
			//trace("Needed: " + string(enemiesLeft));
			global.notChecked = false;
		}
		
		if(enemiesLeft > 0){
			if(instance_exists(enemy)){
				with (enemy) if (my_health <= 0 && checked){ 
					//trace("killed");
					other.enemiesLeft -= kills;
					//trace("Total: " + string(other.enemiesLeft));
					other.enemyX = x;
					other.enemyY = y;
					//trace("enemy: " + string(x) + " " + string(y));
				}
				//trace("enemy: " + string(enemyX) + " " + string(enemyY));
			}
		}
		if(enemiesLeft <= 0 && global.deployOnce){
			global.deployOnce = false;
			//trace("Deploy the landmaster");
			with instance_create(enemyX, enemyY, Explosion){
				sprite_index = global.spr_beaconblast;
				image_speed = 0.833;
				team = 2;
			}
			with instance_create(enemyX, enemyY, CustomObject){
				team = 2;
				mask_index = mskNone;
				name = "drashbeacon";
				sprite_index = global.spr_beaconspawn;
				image_speed = 0.333;
				depth = -9;
			}
		}
		with instances_matching(CustomObject, "name", "drashbeacon"){
			if(image_index >= image_number - 1 && sprite_index = global.spr_beaconspawn){
				sprite_index = global.spr_beacon;
				image_index = 0;
				global.upAndRunning = true;
				with instance_create(x, y, CustomObject){
					team = 2;
					mask_index = mskNone;
					name = "drashbeaconaura";
					sprite_index = global.spr_beaconaura;
					image_xscale = 4;
					image_yscale = 4;
					image_speed = 0.667; //0.533
					depth = 0;
				}
			}
		}
		
		if(global.upAndRunning && collision_circle(x, y, 105, CustomObject, false, true)){
			//trace("IN");
			reload *= 0.75;
		}
	}
	
	// Shield yay
	if(my_health < current_health){
		damageForShield = damageForShield - (current_health - my_health);
		//trace(string(damageForShield+(current_health - my_health)) + " -> " + string(damageForShield));
		timeBetweenDamage = tbd;
		if(damageForShield <= 0 && my_health > 0 && global.canShield){
			my_health = my_health;
			shieldTime = st;
			damageForShield = 9999;
			notCreated = true;
			global.canShield = false;
		}
	}
	if(shieldTime > 0){
		shieldTime--;
		destroyShield = false;
		if(notCreated){
			notCreated = false;
			with instance_create(x, y, CustomHitme){
				//mask_index = no_mask
				name = "drashshield";
				team = 2;
				depth = -11;
				sprite_index = global.spr_shield;
				image_index = image_index;
				image_speed = 0.35;
			}
		}
		if(shieldTime <= st/3){
			with(instances_matching(CustomHitme, "name", "drashshield")){
				sprite_index = global.spr_shieldcracked;
			}
		}
		notCreated = false;
		candie = 0;
		if((my_health < current_health) && (shieldTime < st-1))
			my_health = current_health;
		//trace("Shield is up for " + string(st - shieldTime) + " frame(s)");
	}
	else{
		candie = 1;
		destroyShield = true;
	}
	
	with (instances_matching(CustomHitme, "name", "drashshield")){
		x = other.x;
		y = other.y;
		hspeed = other.hspeed;
		vspeed = other.vspeed;
		if(other.destroyShield){
			instance_destroy();
		}
	}
	
	if(timeBetweenDamage > 0){
		timeBetweenDamage--;
		//trace("Damage last taken " + string(timeBetweenDamage) + " frame(s) ago");
	}
	if(timeBetweenDamage <= 0 && shieldTime <= 0){
		damageForShield = dfs;
		//trace("Damage needed is now back to " + string(damageForShield));
	}
	
	current_health = my_health;
	
	if(button_pressed(index, "spec")){ // For testing the Shield and whatever else
		//instance_create(x, y, DogGuardian);
		//my_health += 6;
		//view_shake_at(x,y,shakeForThatMuch);
		//shakeForThatMuch += 5;
	}
	
	///  ACTIVE : Dodge  \\\
	if(canspec){

		 // Start Roll:
		if(button_pressed(index, "spec") && !airbourne){
			airbourne = true;		 // r Frame Dodge
			depth = -10;
			flip = f;
			y_original = y;
			distance = 0;
			l = right;
			sound_play(sndRoll); // Sound
			canStomp = true;
			
		}
	}
	if(airbourne){
		if(button_pressed(index, "spec"))
			canStomp = true;
		mask_index = no_mask;
		right = l;
		
		//I totally just stole this code from mario2 I'm sorry
		#region
		
		if (floor_meeting(x + (1.5*hspeed), y_original, Wall) and hspeed != 0){
			hspeed = 0;
			//trace("X being violated");
		}
		if (floor_meeting(x, y_original + (1.5*vspeed), Wall) and vspeed != 0){
			vspeed = 0;
			//trace("Y being violated");
		}
		
		#endregion
		
		canfire = 0;
		if(flip > 0){
			flip--;
			sprite_angle -= 39.5 * right;	// Rotate (rotation = 400 / rollTime rounded down)
		}
		else{
			sprite_angle = 0;
		}
		
		//instance_create(x + random_range(-3, 3), y + random(6), Dust); // Dust Particles:
		
		y_original = y + distance;
		//trace(string(distance));
		y += z_vel;
		distance -= z_vel;
		spr_shadow_y = distance;
		z_vel += z_grav;
		//trace("Y: " + string(y) + ", oY: " + string(y_original));
			
		// On Dodge End:
		if(distance <= 0){
			//trace("Y: " + string(y) + ", oY: " + string(y_original));
			mask_index = mskBanditBoss;
			y = y_original;
			z_vel = v;
			
			// Checking if a Stomp was successful
			if(((place_meeting(x, y, enemy) || place_meeting(x,y,prop))) && canStomp)
			{
				with(enemy) {
					if(place_meeting(x, y, other) && stompTime <= 0){
						//trace(stompTime);
						stompTime = 16;
						if(skill_get(5)){
							staggered = 60;
						} else {
							staggered = 30;
						}
						other.allClear = true;
					}
				}
				with(prop) {
					if(place_meeting(x,y,other) && stompTimeProp <= 0)
					{
						stompTimeProp = 16;
						my_health -= 25;
						other.allClear = true;
					}
				}
			}
			// Closure to the Stomp case
			if(allClear){
				//trace("Can Do!");
				with instance_create(x, y, CustomSlash){
					damage = 0;
					mask_index = mskBanditBoss;
				}
				mask_index = no_mask;
				z_vel = v;
				flip = f;
				combo++;
				canStomp = false;
				trace(string(combo));
				allClear = false;
			}
			else
			{
				//trace("Y: " + string(y) + ", oY: " + string(y_original));
				depth = depthOriginal;
				airbourne = false;
				spr_shadow_y = 0;
				mask_index = reg_mask;
				canfire = 1;
				canStomp = true;
				hspeed = 0;
				vspeed = 0;
				
				// Ultra A: Antivoid Combo Strike
				if(ultra_get("drash", 1)){
					if(combo > 1){
						with instance_create(x, y, PopoExplosion){
							creator = other;
							team = 2;
							damage = other.combo * 3;
							sprite_index = global.spr_combostrike;
							alarm0 = -1;
							image_xscale = 2 * ((other.combo - 1) * 0.2);
							image_yscale = 2 * ((other.combo - 1) * 0.2);
						}
						sound_play_pitchvol(sndExplosionS,0.8+random(0.2),1);
						view_shake_at(x,y,combo*5);
					}
				}
				combo = 0;
			}
		}
	}
	else{
		mask_index = reg_mask;
		//y_original = y;
		//trace("CHECK HERE");
	}
	
	// How enemies feel after being stomped
	with(enemy) {	
		if(stompTime > 0)
		{
			//trace(string(stompTime));
			stompTime--;
			image_blend = c_blue;
			image_alpha = ($FFF8B2FF >> 24) / $ff;
		}
		else if(staggered > 0){
			if(skill_get(5)) {
				image_blend = c_yellow;
				image_alpha = ($FFF8B2FF >> 24) / $ff;
			}
			else {
				image_blend = $FFF8B2FF & $ffffff;
				image_alpha = ($FFF8B2FF >> 24) / $ff;
			}
		}
		else{
			image_blend = $FFFFFFFF & $ffffff;
			image_alpha = ($FFFFFFFF >> 24) / $ff;
		}
		if(staggered > 0)
		{
			staggered--;
			hspeed = 0;
			vspeed = 0;
		}
	}
	with(prop) {	
		if(stompTimeProp > 0)
		{
			stompTimeProp--;
			image_blend = $FFF8B2FF & $ffffff;
			image_alpha = ($FFF8B2FF >> 24) / $ff;
		}
		else{
			image_blend = $FFFFFFFF & $ffffff;
			image_alpha = ($FFFFFFFF >> 24) / $ff;
		}
	}

//stole this from mario2 too
#define floor_meeting(_x, _y, _obj)
var bs = 6;
return(collision_rectangle(_x - bs, _y - bs, _x + bs, _y + bs, _obj, true, true) != noone);

 // Name:
#define race_name
	return global.name[player_get_skin(0)];
#define race_skin_name 
	return global.loadout[argument0];


 // Description:
#define race_text
	return "@wSHIELD WHEN @rINJURED#@wCAN DODGE";


 // Starting Weapon:
#define race_swep
	return 1; // 5 for shotgun


 // Throne Butt Description:
#define race_tb_text
	return "THUNDER SOLES";


 // On Taking Throne Butt:
#define race_tb_take


 // Character Selection Icon:
#define race_menu_button
	sprite_index = global.spr_slct;


 // Portrait:
#define race_portrait
	return global.spr_port;


 // Loading Screen Map Icon:
#define race_mapicon
	return global.spr_icon;


 // Skin Count:
#define race_skins
	return 2; // 2 skins


 // Skin Icons:
#define race_skin_button
	sprite_index = global.spr_skin;
	image_index = argument0;

 // Ultra Names:
#define race_ultra_name
	switch(argument0){
		case 1: return "ANTIVOID COMBO STRIKE";
		case 2: return "KINDRED CONTACT";
		/// Add more cases if you have more ultras!
	}


 // Ultra Descriptions:
#define race_ultra_text
	switch(argument0){
		case 1: return "@wEXPLOSIVE COMBINATION CHARGING";
		case 2: return "@wBEACONS BOOST ATTACK SPEED";
		/// Add more cases if you have more ultras!
	}


 // On Taking An Ultra:
#define race_ultra_take
	if(instance_exists(mutbutton)) switch(argument0){
		 // Play Ultra Sounds:
		case 1:	sound_play(sndFishUltraA); break;
		case 2: sound_play(sndFishUltraB); break;
		/// Add more cases if you have more ultras!
	}


 // Ultra Button Portraits:
#define race_ultra_button
	sprite_index = global.spr_ult_slct;
	image_index = argument0 + 1;


 // Ultra HUD Icons:
#define race_ultra_icon
	return global.spr_ult_icon[argument0];


 // Loading Screen Tips:
#define race_ttip
	//These tips feel too memey but idk you tell me//These tips feel too memey but idk you tell me
	if((ultra_get("drash", 1) || ultra_get("drash", 2)) && irandom(2) == 1){
		if(ultra_get("drash", 1))
			return "SURGING WITH POWER";
		else
			return "SENSING A CONNECTION";
	}
	else
		return choose("LET'S VOIDI GO", 
					  "NEVER AS HAPPY AS A BEETLE", 
					  "IT'S DRASHIN' TIME", 
					  "SOMEONE ELSE HAS CONTROL HERE", 
					  "WHO WAS I", 
					  "FULFILL YOUR PURPOSE");