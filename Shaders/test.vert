varying vec3 g_colour;
//varying vec3 g_normal;
//varying vec3 g_tangent;
//varying vec3 g_binormal;

//attribute vec3 tangent;
//attribute vec3 binormal;

void main(void)
{
//	vec4 l_vertex = gl_ModelViewMatrix * gl_Vertex;

//	g_normal = vec3( abs( gl_Normal.x), abs( gl_Normal.y), abs( gl_Normal.z));
//	g_tangent = vec3( abs( tangent.x), abs( tangent.y), abs( tangent.z));
//	g_binormal = cross( g_normal, g_tangent);
//	g_binormal = vec3( abs( g_binormal.x), abs( g_binormal.y), abs( g_binormal.z));

	g_colour = gl_Normal;

	gl_Position = ftransform();
}