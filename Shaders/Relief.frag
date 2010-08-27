uniform float depth;
uniform float tile;
uniform int linear_search_steps;
uniform int binary_search_steps;
   
varying vec2 texCoord;
varying vec3 eyeSpaceVert;
varying vec3 eyeSpaceTangent;
varying vec3 eyeSpaceBinormal;
varying vec3 eyeSpaceNormal;
varying vec3 eyeSpaceLight;

uniform sampler2D reliefmap;
uniform sampler2D texmap;
uniform sampler2D gloss;

float ray_intersect_rm(in vec2 dp,in vec2 ds);

void main(void)
{
	vec4 ambient = gl_FrontMaterial.ambient;
	vec4 specular = gl_FrontMaterial.specular;
	vec4 diffuse = gl_FrontMaterial.diffuse;
	float shine = gl_FrontMaterial.shininess;

	vec4 t,c;
	vec3 p,v,l,s;
	vec2 dp,ds,uv;
	float d,a;

	// ray intersect in view direction
	p  = eyeSpaceVert;
	v  = normalize(p);
	a  = dot(eyeSpaceNormal,-v);
	s  = normalize(vec3(dot(v,eyeSpaceTangent),dot(v,eyeSpaceBinormal),a));
	s  *= depth/a;
	dp = texCoord*tile;
	ds = s.xy;
	d  = ray_intersect_rm(dp,ds);

	// get rm and color texture points
	uv=dp+ds*d;
	t=texture2D(reliefmap,uv);
	c=texture2D(texmap,uv);

	// expand normal from normal map in local polygon space
	t.xy=t.xy*2.0-1.0;
	t.z=sqrt(1.0-dot(t.xy,t.xy));
	t.xyz=normalize(t.x*eyeSpaceTangent+t.y*eyeSpaceBinormal+t.z*eyeSpaceNormal);

	// compute light direction
	p += v*d*a;
	l=normalize(p-eyeSpaceLight.xyz);
   
	// ray intersect in light direction
	dp+= ds*d;
	a  = dot(eyeSpaceNormal,-l);
	s  = normalize(vec3(dot(l,eyeSpaceTangent),dot(l,eyeSpaceBinormal),a));
	s *= depth/a;
	ds = s.xy;
	dp-= ds*d;
	float dl = ray_intersect_rm(dp,s.xy);
	float shadow = 1.0;
	vec3 specular_shadow=specular.xyz;
	if (dl<d-0.05) // if pixel in shadow
	{
		shadow=dot(ambient.xyz,vec3(1.0))*0.333333;
		specular_shadow=vec3(0.0);
	}

	// compute diffuse and specular terms
	float att=max(0.0,dot(-l,eyeSpaceNormal));
	float diff=shadow*max(0.0,dot(-l,t.xyz));
	float spec=max(0.0,dot(normalize(-l-v),t.xyz));

	// compute final color
	vec4 finalcolor;
	finalcolor.xyz=ambient.xyz*c.xyz+att*(c.xyz*diffuse.xyz*diff+specular_shadow*pow(spec,shine));
	finalcolor.w=1.0;   
	gl_FragColor = vec4(finalcolor.rgb,1.0);
}

float ray_intersect_rm(in vec2 dp, in vec2 ds)
{
   //const int linear_search_steps=20;
   //const int binary_search_steps=5;
   float depth_step=1.0/float(linear_search_steps);

   // current size of search window
   float size=depth_step;
   // current depth position
   float depth=0.0;
   // best match found (starts with last position 1.0)
   float best_depth=1.0;

   // search front to back for first point inside object
   for( int i=0;i<linear_search_steps-1;i++ )
   {
      depth+=size;
      vec4 t=texture2D(reliefmap,dp+ds*depth);

      if (best_depth>0.996)   // if no depth found yet
      if (depth>=t.w)
         best_depth=depth;   // store best depth
   }
   depth=best_depth;
   
   // recurse around first point (depth) for closest match
   for( int i=0;i<binary_search_steps;i++ )
   {
      size*=0.5;
      vec4 t=texture2D(reliefmap,dp+ds*depth);
      if (depth>=t.w)
      {
         best_depth=depth;
         depth-=2.0*size;
      }
      depth+=size;
   }

   return best_depth;
}
