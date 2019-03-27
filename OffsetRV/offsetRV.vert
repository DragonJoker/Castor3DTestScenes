attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

varying vec3 eyeVec;

varying float vEchelleHeightMap;
uniform float HeightMapScale;

varying float vEchelle;
uniform float Scale;

varying vec3 PositionVertex;
varying vec3 NormaleVertex;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsDiffuse[8];

varying vec3 Light0_Position;
varying vec3 Light1_Position;
varying vec3 Light2_Position;
varying vec3 Light3_Position;

varying vec4 Light0_Ambient;
varying vec4 Light1_Ambient;
varying vec4 Light2_Ambient;
varying vec4 Light3_Ambient;

varying vec4 Light0_Diffuse;
varying vec4 Light1_Diffuse;
varying vec4 Light2_Diffuse;
varying vec4 Light3_Diffuse;

varying vec2 TexCoord;

void main() 
{ 
	TexCoord = MultiTexCoord0; 
	 
	vEchelleHeightMap = HeightMapScale;
	vEchelle = Scale;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	// transforme le vecteur vision :
	vec4 VertexModelView = ModelViewMatrix * vertex; 
	eyeVec = vec3( -VertexModelView) * TBN_Matrix ;     

	// transforme le vecteur lumiere :
//	Light0_Position = (ModelViewMatrix * gl_LightSource[0].position).xyz;// * TBN_Matrix;
//	Light1_Position = (ModelViewMatrix * gl_LightSource[1].position).xyz;// * TBN_Matrix;
//	Light2_Position = (ModelViewMatrix * gl_LightSource[2].position).xyz;// * TBN_Matrix;
//	Light3_Position = (ModelViewMatrix * gl_LightSource[3].position).xyz;// * TBN_Matrix;

	Light0_Position = (ModelViewMatrix * in_LightsPosition[0]).xyz;// * TBN_Matrix;
	Light1_Position = (ModelViewMatrix * in_LightsPosition[1]).xyz;// * TBN_Matrix;
	Light2_Position = (ModelViewMatrix * in_LightsPosition[2]).xyz;// * TBN_Matrix;

	Light0_Ambient = in_LightsAmbient[0];
	Light1_Ambient = in_LightsAmbient[1];
	Light2_Ambient = in_LightsAmbient[2];

	Light0_Diffuse = in_LightsDiffuse[0];
	Light1_Diffuse = in_LightsDiffuse[1];
	Light2_Diffuse = in_LightsDiffuse[2];

	PositionVertex = vec3( ModelViewMatrix * vertex) * TBN_Matrix;
	NormaleVertex = normalize( NormalMatrix * normal);

	// Vertex transformation 
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
