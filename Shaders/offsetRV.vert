attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

varying vec3 eyeVec;

varying float vEchelleHeightMap;
uniform float EchelleHeightMap;

varying float vEchelle;
uniform float Echelle;

varying vec3 PositionVertex;
varying vec3 NormaleVertex;

varying vec3 Light0_Position;
varying vec3 Light1_Position;
varying vec3 Light2_Position;
varying vec3 Light3_Position;

varying vec2 TexCoord;

void main()
{ 
	TexCoord = MultiTexCoord0; 

	vEchelleHeightMap = EchelleHeightMap;
	vEchelle = Echelle;

	vec3 binormal = cross( tangent, normal);

	mat3 TBN_Matrix;
	TBN_Matrix[0] =  NormalMatrix * tangent;
	TBN_Matrix[1] =  NormalMatrix * binormal;
	TBN_Matrix[2] =  NormalMatrix * normal;

	// transforme le vecteur vision :
	vec4 VertexModelView = ModelViewMatrix * vertex; 
	eyeVec = vec3( -VertexModelView) * TBN_Matrix;

	// transforme le vecteur lumiere :
	Light0_Position = gl_LightSource[0].position.xyz * TBN_Matrix;
	Light1_Position = gl_LightSource[1].position.xyz * TBN_Matrix;
	Light2_Position = gl_LightSource[2].position.xyz * TBN_Matrix;
	Light3_Position = gl_LightSource[3].position.xyz * TBN_Matrix;

	PositionVertex = vec3( ModelViewMatrix * vertex) * TBN_Matrix;
	NormaleVertex = normalize( NormalMatrix * normal);

	// Vertex transformation 
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
