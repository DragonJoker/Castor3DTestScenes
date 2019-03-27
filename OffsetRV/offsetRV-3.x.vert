#version 140

in vec3 tangent;
in vec4 vertex;
in vec3 normal;
in vec2 texture;

uniform mat4 ProjectionMatrix;
uniform mat4 ProjectionModelViewMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

out vec3 eyeVec;

out float vEchelleHeightMap;
uniform float HeightMapScale;

out float vEchelle;
uniform float Scale;

out vec3 PositionVertex;
out vec3 NormaleVertex;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsDiffuse[8];

out vec3 Light0_Position;
out vec3 Light1_Position;
out vec3 Light2_Position;
out vec3 Light3_Position;

out vec4 Light0_Ambient;
out vec4 Light1_Ambient;
out vec4 Light2_Ambient;
out vec4 Light3_Ambient;

out vec4 Light0_Diffuse;
out vec4 Light1_Diffuse;
out vec4 Light2_Diffuse;
out vec4 Light3_Diffuse;

out vec2 TexCoord;

void main() 
{ 
	TexCoord = texture; 
	 
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
	gl_Position = ProjectionModelViewMatrix * vertex;
}
