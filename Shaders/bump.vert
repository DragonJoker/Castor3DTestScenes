uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;

attribute vec4 vertex;
attribute vec3 normal;
attribute vec3 tangent;
attribute vec2 MultiTexCoord0;

varying vec2 TexCoord;
varying vec3 textureLight;
varying vec3 textureEye;

void main(void)
{
	TexCoord = MultiTexCoord0;

	vec3 n = (ModelViewMatrix*vec4(normal, 0.0)).xyz;
	vec3 t = (ModelViewMatrix*vec4(tangent, 0.0)).xyz;
	vec3 b = cross( n, t);

	vec3 light = normalize( gl_LightSource[0].position.xyz);

	textureLight.x = dot(light, t);
	textureLight.y = dot(light, b);
	textureLight.z = dot(light, n);
	
	vec3 eye = (ModelViewMatrix * vertex).xyz;
	eye = normalize(-eye);
	
	textureEye.x = dot(eye, t);
	textureEye.y = dot(eye, b);
	textureEye.z = dot(eye, n);

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
