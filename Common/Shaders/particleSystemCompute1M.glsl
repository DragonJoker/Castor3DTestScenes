#version 430
layout(local_size_x = 32, local_size_y = 32, local_size_z = 1)in;

#define inLauncherCooldown 0.1
#define inShellLifetime 1.0
#define inSecondaryShellLifetime 2.0
#define inFinalShellLifetime 250000.0

#define PARTICLE_TYPE_LAUNCHER 0
#define PARTICLE_TYPE_SHELL 1
#define PARTICLE_TYPE_SECONDARY_SHELL 2
#define PARTICLE_TYPE_FINAL_SHELL 3

struct Particle
{
	vec3 position;
	int type;
	vec3 velocity;
	float age;
};

layout( std430, binding = 0 ) buffer C3D_Index
{
	uint c3d_outIndex;
	uint c3d_inIndex;
};

layout( std430, binding = 1 ) buffer C3D_Random
{
	vec4 c3d_random[1024];
};

layout( std430, binding = 2 ) buffer C3D_ParticlesIn
{
	Particle c3d_inParticles[];
};

layout( std430, binding = 3 ) buffer C3D_ParticlesOut
{
	Particle c3d_outParticles[];
};

layout( std140, binding = 4 ) uniform C3D_ParticleSystem
{
	float c3d_deltaTime;
	float c3d_totalTime;
	uint c3d_maxParticlesCount;
	uint c3d_currentParticlesCount;
	vec3 c3d_emitterPosition;
};

vec3 GetRandomDir( float uv )
{
	uint index = uint( mod( uv, 1024.0 ) );
	return c3d_random[index].xyz;
}

void EmitParticle( in int type, in vec3 position, in vec3 velocity, in float age )
{
	uint index = atomicAdd( c3d_outIndex, 1u );

	if ( index < c3d_maxParticlesCount )
	{
		c3d_outParticles[index].position = position;
		c3d_outParticles[index].type = type;
		c3d_outParticles[index].velocity = velocity;
		c3d_outParticles[index].age = age;
	}
}

void main()
{
	uint gid = atomicAdd( c3d_inIndex, 1u );

	if ( gid < c3d_currentParticlesCount )
	{
		Particle inParticle = c3d_inParticles[gid];
		float age = inParticle.age + c3d_deltaTime;
		int type = inParticle.type;
		vec3 position = inParticle.position;
		vec3 velocity = inParticle.velocity;

		switch ( type )
		{
		case PARTICLE_TYPE_LAUNCHER:
			if ( age >= inLauncherCooldown )
			{
				age = 0.0;
				vec3 dir = GetRandomDir( c3d_totalTime ) * 25.0;
				EmitParticle( PARTICLE_TYPE_SHELL
					, position
					, dir
					, age );
			}
			EmitParticle( PARTICLE_TYPE_LAUNCHER
				, c3d_emitterPosition
				, velocity
				, age );
			break;

		case PARTICLE_TYPE_SHELL:
			if ( age < inShellLifetime )
			{
				float deltaTime = c3d_deltaTime / 1000.0;
				vec3 deltaP = vec3( deltaTime ) * velocity;
				vec3 deltaV = vec3( deltaTime ) * vec3( -0.2, -0.2, -0.2 );
				EmitParticle( PARTICLE_TYPE_SHELL
					, position + deltaP
					, velocity + deltaV
					, age );
			}
			else
			{
				for ( int i = 0; i < 10; i++ )
				{
					vec3 dir = GetRandomDir( c3d_totalTime + i ) * 5.0;
					EmitParticle( PARTICLE_TYPE_SECONDARY_SHELL
						, position
						, dir + velocity / 2
						, 0.0 );
				}
			}
			break;

		case PARTICLE_TYPE_SECONDARY_SHELL:
			if ( age < inSecondaryShellLifetime )
			{
				float deltaTime = c3d_deltaTime / 1000.0;
				vec3 deltaP = vec3( deltaTime ) * velocity;
				vec3 deltaV = vec3( deltaTime ) * vec3( -0.2, -0.2, -0.2 );
				EmitParticle( PARTICLE_TYPE_SECONDARY_SHELL
					, position + deltaP
					, velocity + deltaV
					, age );
			}
			else
			{
				for ( int i = 0; i < 10; i++ )
				{
					vec3 dir = GetRandomDir( c3d_totalTime + i ) * 5.0;
					EmitParticle( PARTICLE_TYPE_FINAL_SHELL
						, position
						, dir + velocity / 2
						, 0.0 );
				}
			}
			break;

		case PARTICLE_TYPE_FINAL_SHELL:
			if ( age < inFinalShellLifetime )
			{
				float deltaTime = c3d_deltaTime / 1000.0;
				vec3 deltaP = vec3( deltaTime ) * velocity;
				vec3 deltaV = vec3( deltaTime ) * vec3( -0.2, -0.2, -0.2 );
				EmitParticle( PARTICLE_TYPE_FINAL_SHELL
					, position + deltaP
					, velocity + deltaV
					, age );
			}
			break;
		}
	}
}
