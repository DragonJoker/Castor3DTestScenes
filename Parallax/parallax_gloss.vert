attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsDiffuse[8];

varying vec4 ex_Light0Diffuse;

varying vec2 TexCoord;

// inverse light radius ie.. 1.0/light radius;
uniform float u_invRad;

varying	vec3 g_lightVec;
varying	vec3 g_viewVec;

void main()
{
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
	TexCoord = MultiTexCoord0;
	vec3 binormal = cross( tangent, normal);
	
	mat3 TBN_Matrix = NormalMatrix * mat3( tangent, binormal, normal);
	vec4 mv_Vertex = ModelViewMatrix * vertex;
	g_viewVec = vec3(-mv_Vertex) * TBN_Matrix;	
	vec4 lightEye = ModelViewMatrix *  in_LightsPosition[0];
//	vec4 lightEye = ModelViewMatrix *  gl_LightSource[0].position;
	vec3 lightVec =0.02 * (lightEye.xyz - mv_Vertex.xyz);				
	g_lightVec = lightVec * TBN_Matrix;
//	ex_Light0Diffuse = vec4( 1.0, 0.0, 0.0, 1.0);
	ex_Light0Diffuse = in_LightsDiffuse[0];
}


