#!/usr/bin/python

startIndex = 1292

channels = ["albedo", "roughness", "metalness", "emissive", "opacity", "occlusion", "normal", "height", "reflection", "refraction"]
channelsMasks = ["0x00ffffff", "0x00ff0000", "0x00ff0000", "0x00ffffff", "0xff000000", "0x00ff0000", "0x00ffffff", "0x00ff0000", "", ""]
extensions = ["jpg", "jpg", "jpg", "png", "png", "jpg", "jpg", "jpg", "", ""]
options = ["",
    "",
    "",
    "emissive 1.0",
    'two_sided true\n			mixed_interpolation true',
    "",
    "",
    "parallax_occlusion one",
    "",
    "refraction_ratio 0.92"]

def writeChannel( file, channel, channelMask, extension ):
	if channel != "reflection" and channel != "refraction":
		file.write( '\n' )
		file.write( '			texture_unit\n' )
		file.write( '			{\n' )
		file.write( '				' + channel + '_mask ' + channelMask + '\n' )
		file.write( '				sampler "Linear"\n' )
		file.write( '				image "Textures/Cube/' + channel + '.' + extension + '"\n' )
		file.write( '			}\n' )
	else:
		if channel != "reflection":
			file.write( '			transmission 1.0 1.0 1.0\n' )
		file.write( '			' + channel + 's true\n' )

def writeFile( file, indices ):
	file.write( 'materials pbr\n' )
	file.write( '\n' )
	file.write( 'scene "Scene"\n' )
	file.write( '{\n' )
	file.write( '	ambient_light 1.0 1.0 1.0\n' )
	file.write( '\n' )
	file.write( '	skybox\n' )
	file.write( '	{\n' )
	file.write( '		equirectangular "Textures/cityCenterSkybox.hdr" 1024\n' )
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
	file.write( '			albedo 0.75164 0.75164 0.75164 1.0\n' )
	if 0 in indices:
		if 8 in indices or 9 in indices:
			file.write( '			metalness 0.628281\n' )
		else:
			file.write( '			metalness 0.0\n' )
	else:
		file.write( '			metalness 0.628281\n' )
	if 8 in indices or 9 in indices:
		file.write( '			roughness 0.4\n' )
	else:
		file.write( '			roughness 0.8\n' )
	for i in indices:
		if len( options[i] ) > 0:
			file.write( '			' + options[i] + '\n' )
	for i in indices:
		writeChannel( file, channels[i], channelsMasks[i], extensions[i] )
	file.write( '		}\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "LightNode"\n' )
	file.write( '	{\n' )
	file.write( '		orientation 1 0 0 45\n' )
	file.write( '	}\n' )
	file.write( '	light "SunLight1"\n' )
	file.write( '	{\n' )
	file.write( '		parent "LightNode"\n' )
	file.write( '		type directional\n' )
	file.write( '		colour 1.0 1.0 1.0\n' )
	file.write( '		intensity 0.8 1.0\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "FinalNode"\n' )
	file.write( '	{\n' )
	file.write( '		position 0.0 0.0 0.0\n' )
	file.write( '	}\n' )
	file.write( '	mesh "Mesh"\n' )
	file.write( '	{\n' )
	file.write( '		type "cube" -width=50 -height=50 depth=50\n' )
	file.write( '		default_material "Textured"\n' )
	file.write( '	}\n' )
	file.write( '	object "FinalPrimitive"\n' )
	file.write( '	{\n' )
	file.write( '		parent "FinalNode"\n' )
	file.write( '		mesh "Mesh"\n' )
	file.write( '	}\n' )
	file.write( '\n' )
	file.write( '	scene_node "MainCameraNode"\n' )
	file.write( '	{\n' )
	file.write( '		position 87.3926 -3.91655 -82.7833\n' )
	file.write( '		orientation 0.0 1.0 0.0 315.0\n' )
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
	file.write( '			near 1.0\n' )
	file.write( '			far 2000.0\n' )
	file.write( '		}\n' )
	file.write( '	}\n' )
	file.write( '}\n' )
	file.write( '\n' )
	file.write( 'window "Window"\n' )
	file.write( '{\n' )
	file.write( '	fullscreen false\n' )
	file.write( '	vsync false\n' )
	file.write( '	render_target\n' )
	file.write( '	{\n' )
	file.write( '		format argb32\n' )
	file.write( '		size 800 600\n' )
	file.write( '		scene "Scene"\n' )
	file.write( '		camera "MainCamera"\n' )
	file.write( '	}\n' )
	file.write( '}\n' )
	file.write( '\n' )

def generate1Channel( index, count, begin, end ):
	global startIndex
	for i in range( begin, end ):
		file = open( "Test-{:04}".format( startIndex ) + ".cscn", "w" )
		startIndex = startIndex + 1
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		writeFile( file, list )
		file.close()

generate1Channel( -1, 1, 0, len( channels ) - 0 )

def generate2Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate1Channel( list, count, i + 1, end + 1 )

generate2Channels( -1, 2, 0, len( channels ) - 1 )

def generate3Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate2Channels( list, count, i + 1, end + 1 )

generate3Channels( -1, 3, 0, len( channels ) - 2 )

def generate4Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate3Channels( list, count, i + 1, end + 1 )

generate4Channels( -1, 4, 0, len( channels ) - 3 )

def generate5Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate4Channels( list, count, i + 1, end + 1 )

generate5Channels( -1, 5, 0, len( channels ) - 4 )

def generate6Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate5Channels( list, count, i + 1, end + 1 )

generate6Channels( -1, 6, 0, len( channels ) - 5 )

def generate7Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate6Channels( list, count, i + 1, end + 1 )

generate7Channels( -1, 7, 0, len( channels ) - 6 )

def generate8Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate7Channels( list, count, i + 1, end + 1 )

generate8Channels( -1, 8, 0, len( channels ) - 7 )

def generate9Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate8Channels( list, count, i + 1, end + 1 )

generate9Channels( -1, 9, 0, len( channels ) - 8 )

def generate10Channels( index, count, begin, end ):
	for i in range( begin, end ):
		list = []
		if index != -1:
			list = index[:]
		list.append( i )
		generate9Channels( list, count, i + 1, end + 1 )

generate10Channels( -1, 10, 0, len( channels ) - 9 )
