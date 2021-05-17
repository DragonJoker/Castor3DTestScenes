#version 430
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1)in;

#define in_launcherCooldown 100.0
#define in_shellLifetime 10000.0
#define in_secondaryShellLifetime 2500.0

#define PARTICLE_TYPE_LAUNCHER 0
#define PARTICLE_TYPE_SHELL 1
#define PARTICLE_TYPE_SECONDARY_SHELL 2

struct Particle
{
	vec4 positionType;
	vec4 velocityAge;
};

layout( std140, binding = 0 ) buffer Index
{
	uint out_index;
	uint in_index;
};

layout( std140, binding = 1 ) buffer Random
{
	vec4 random[1024];
};

layout( std140, binding = 2 ) buffer ParticlesIn
{
	Particle particles_in[];
};

layout( std140, binding = 3 ) buffer ParticlesOut
{
	Particle particles_out[];
};

layout( std140, binding = 4 ) uniform ParticleSystem
{
	float c3d_fDeltaTime;
	float c3d_fTotalTime;
	uint c3d_uiMaxParticlesCount;
	uint c3d_uiCurrentParticlesCount;
	vec3 c3d_v3EmitterPosition;
};

vec3 GetRandomDir( float p_uv )
{
	uint l_uv = uint( mod( p_uv, 1024.0 ) );
	return random[l_uv].xyz;
}

void EmitParticle( in float p_type, in vec3 p_position, in vec3 p_velocity, in float p_age )
{
	uint l_index = atomicAdd( out_index, 1u );
	particles_out[l_index].positionType = vec4( p_position, p_type );
	particles_out[l_index].velocityAge = vec4( p_velocity, p_age );
}

void main()
{
	uint l_gid = atomicAdd( in_index, 1u );

	if ( l_gid < c3d_uiCurrentParticlesCount )
	{
		Particle l_in = particles_in[l_gid];
		float l_age = l_in.velocityAge.w + c3d_fDeltaTime;
		int l_type = int( l_in.positionType.w );
		vec3 l_position = l_in.positionType.xyz;
		vec3 l_velocity = l_in.velocityAge.xyz;

		switch ( l_type )
		{
		case PARTICLE_TYPE_LAUNCHER:
			if ( l_age >= in_launcherCooldown )
			{
				l_age = 0.0;
				vec3 l_dir = GetRandomDir( c3d_fTotalTime ) * 5.0;
				l_dir.y = max( l_dir.y * 7.0, 10.0 );
				EmitParticle(
					PARTICLE_TYPE_SHELL,
					l_position,
					l_dir,
					l_age );
			}
			EmitParticle(
				PARTICLE_TYPE_LAUNCHER,
				c3d_v3EmitterPosition,
				l_velocity,
				l_age );
			break;

		case PARTICLE_TYPE_SHELL:
			if ( l_age < in_shellLifetime )
			{
				float l_deltaTime = c3d_fDeltaTime / 1000.0;
				vec3 l_deltaP = vec3( l_deltaTime ) * l_velocity;
				vec3 l_deltaV = vec3( l_deltaTime ) * vec3( 0.0, -0.981, 0.0 );
				EmitParticle(
					PARTICLE_TYPE_SHELL,
					l_position + l_deltaP,
					l_velocity + l_deltaV,
					l_age );
			}
			else
			{
				for ( int i = 0; i < 10; i++ )
				{
					vec3 l_dir = GetRandomDir( c3d_fTotalTime + i ) * 5.0;
					EmitParticle(
						PARTICLE_TYPE_SECONDARY_SHELL,
						l_position,
						l_dir + l_velocity / 2,
						0.0 );
				}
			}
			break;

		case PARTICLE_TYPE_SECONDARY_SHELL:
			if ( l_age < in_secondaryShellLifetime )
			{
				float l_deltaTime = c3d_fDeltaTime / 1000.0;
				vec3 l_deltaP = vec3( l_deltaTime ) * l_velocity;
				vec3 l_deltaV = vec3( l_deltaTime ) * vec3( 0.0, -0.981, 0.0 );
				EmitParticle(
					PARTICLE_TYPE_SECONDARY_SHELL,
					l_position + l_deltaP,
					l_velocity + l_deltaV,
					l_age );
			}
			break;
		}
	}
}
