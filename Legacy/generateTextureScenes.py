#!/usr/bin/python

startIndex = 230

channels = ["diffuse", "shininess", "specular", "emissive", "opacity", "occlusion", "normal", "height", "reflection", "refraction"]
materials = ["reflection", "refraction"]
extensions = ["jpg", "jpg", "jpg", "jpg", "png", "jpg", "jpg", "jpg", "", ""]
options = ["", "", "", "emissive 1.0", 'two_sided true\n			mixed_interpolation true', "", "", "parallax_occlusion one", "", "refraction_ratio 0.92"]

def writeChannel( file, channel, extension ):
	if channel != "reflection" and channel != "refraction":
		file.write( '\n' )
		file.write( '			texture_unit\n' )
		file.write( '			{\n' )
		file.write( '				channel ' + channel + '\n' )
		file.write( '				sampler "Linear"\n' )
		file.write( '				image "Textures/Bricks/' + channel.capitalize() + '.' + extension + '"\n' )
		file.write( '			}\n' )
	else:
		if channel != "reflection":
			file.write( '			transmission 1.0 1.0 1.0\n' )
		file.write( '			' + channel + 's true\n' )

def writeFile( file, indices ):
	file.write( 'materials phong\n' )
	file.write( '\n' )
	file.write( 'scene "Scene"\n' )
	file.write( '{\n' )
	file.write( '	ambient_light 0.2 0.2 0.2\n' )
	file.write( '\n' )
	file.write( '	skybox\n' )
	file.write( '	{\n' )
	file.write( '		equirectangular "Textures/equirectangularSkybox.hdr" 512\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	sampler "Linear"\n' )
	file.write( '	{\n' )
	file.write( '		min_filter linear\n' )
	file.write( '		mag_filter linear\n' )
	file.write( '		min_lod 0.0\n' )
	file.write( '		max_lod 0.0\n' )
	file.write( '		lod_bias 0.0\n' )
	file.write( '		u_wrap_mode clamp_to_edge\n' )
	file.write( '		v_wrap_mode clamp_to_edge\n' )
	file.write( '		w_wrap_mode clamp_to_edge\n' )
	file.write( '		border_colour float_opaque_black\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	material "Textured"\n' )
	file.write( '	{\n' )
	file.write( '		pass\n' )
	file.write( '		{\n' )
	file.write( '			diffuse 0.75164 0.75164 0.75164\n' )
	file.write( '			specular 0.628281 0.628281 0.628281\n' )
	file.write( '			ambient 1.0\n' )
	file.write( '			shininess 192.0\n' )
	for i in indices:
		if len( options[i] ) > 0:
			file.write( '			' + options[i] + '\n' )
	for i in indices:
		writeChannel( file, channels[i], extensions[i] )
	file.write( '		}\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "SunLightNode1"\n' )
	file.write( '	{\n' )
	file.write( '		orientation 1 0 0 45\n' )
	file.write( '	}\n' )
	file.write( '	light "SunLight1"\n' )
	file.write( '	{\n' )
	file.write( '		parent "SunLightNode1"\n' )
	file.write( '		type directional\n' )
	file.write( '		colour 1.0 1.0 1.0\n' )
	file.write( '		intensity 0.8 1.0\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "FinalNode"\n' )
	file.write( '	{\n' )
	file.write( '		position 0.0 0.0 0.0\n' )
	file.write( '	}\n' )
	file.write( '	object "FinalPrimitive"\n' )
	file.write( '	{\n' )
	file.write( '		parent "FinalNode"\n' )
	file.write( '		mesh "Mesh"\n' )
	file.write( '		{\n' )
	file.write( '			type "cube" -width=50 -height=50 depth=50\n' )
	file.write( '		}\n' )
	file.write( '		material "Textured"\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "MainCameraNode"\n' )
	file.write( '	{\n' )
	file.write( '		position 87.3926 -3.91655 -82.7833\n' )
	file.write( '		orientation -0.0337855 -0.999314 -0.0151473 48.3264\n' )
	file.write( '	}\n' )
	file.write( '	camera "MainCamera"\n' )
	file.write( '	{\n' )
	file.write( '		parent "MainCameraNode"\n' )
	file.write( '		primitive triangle_list\n' )
	file.write( '		viewport "MainViewport"\n' )
	file.write( '		{\n' )
	file.write( '			type perspective\n' )
	file.write( '			fov_y 45.0\n' )
	file.write( '			aspect_ratio 1.333\n' )
	file.write( '			near 0.1\n' )
	file.write( '			far 20000.0\n' )
	file.write( '		}\n' )
	file.write( '	}\n' )
	file.write( '}\n' )
	file.write( '\n' )
	file.write( 'window "Window"\n' )
	file.write( '{\n' )
	file.write( '	render_target\n' )
	file.write( '	{\n' )
	file.write( '		format argb32\n' )
	file.write( '		size 800 600\n' )
	file.write( '		scene "Scene"\n' )
	file.write( '		camera "MainCamera"\n' )
	file.write( '	}\n' )
	file.write( '	fullscreen false\n' )
	file.write( '	vsync false\n' )
	file.write( '}\n' )
	file.write( '\n' )

def generate1Channel( names, index, count, begin, end ):
	global startIndex
	for i in range( begin, end ):
		file = open( "{:04}".format( startIndex ) + "-" + names + channels[i].capitalize() + ".cscn", "w" )
		startIndex = startIndex + 1
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		writeFile( file, list )
		file.close()

generate1Channel( "", -1, 1, 0, len( channels ) - 0 )

def generate2Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate1Channel( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate2Channels( "", -1, 2, 0, len( channels ) - 1 )

def generate3Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate2Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate3Channels( "", -1, 3, 0, len( channels ) - 2 )

def generate4Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate3Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate4Channels( "", -1, 4, 0, len( channels ) - 3 )

def generate5Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate4Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate5Channels( "", -1, 5, 0, len( channels ) - 4 )

def generate6Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate5Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate6Channels( "", -1, 6, 0, len( channels ) - 5 )

def generate7Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate6Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate7Channels( "", -1, 7, 0, len( channels ) - 6 )

def generate8Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate7Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate8Channels( "", -1, 8, 0, len( channels ) - 7 )

def generate9Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate8Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate9Channels( "", -1, 9, 0, len( channels ) - 8 )

def generate10Channels( names, index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate9Channels( names + channels[i].capitalize(), list, count, i + 1, end + 1 )

generate10Channels( "", -1, 10, 0, len( channels ) - 9 )
