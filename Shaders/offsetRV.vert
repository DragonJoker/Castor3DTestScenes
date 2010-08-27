attribute vec3 tangent;
//attribute vec3 binormal;
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



void main() 
{ 
	gl_TexCoord[0] = gl_MultiTexCoord0; 
     
	vEchelleHeightMap = EchelleHeightMap;
	vEchelle = Echelle;

	vec3 binormal = cross( gl_Normal, tangent);
		
	mat3 TBN_Matrix;// = mat3(tangent, binormal, gl_Normal);  
	TBN_Matrix[0] =  gl_NormalMatrix * tangent;
	TBN_Matrix[1] =  gl_NormalMatrix * binormal;
	TBN_Matrix[2] =  gl_NormalMatrix * gl_Normal;
	
	// transforme le vecteur vision :
	vec4 Vertex_ModelView = gl_ModelViewMatrix * gl_Vertex; 
	eyeVec = vec3(-Vertex_ModelView) * TBN_Matrix ;     
	
	// transforme le vecteur lumiere :
	Light0_Position = gl_LightSource[0].position.xyz * TBN_Matrix;
	Light1_Position = gl_LightSource[1].position.xyz * TBN_Matrix;
	Light2_Position = gl_LightSource[2].position.xyz * TBN_Matrix;
	Light3_Position = gl_LightSource[3].position.xyz * TBN_Matrix;

	
	//Light0_Position =  vec3(-1.5,- 1.5, 0.0) * TBN_Matrix;

//	Light0_Position = gl_LightSource[0].position.xyz;
//	Light0_Position = vec3(-Light0_Position.z, Light0_Position.y, Light0_Position.x);

//	  	Light0_Position = gl_NormalMatrix[1];
   
	PositionVertex = vec3(gl_ModelViewMatrix * gl_Vertex) * TBN_Matrix;
	NormaleVertex = normalize(gl_NormalMatrix * gl_Normal);
	
	// Vertex transformation 
	gl_Position = ftransform(); 
}
