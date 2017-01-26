/**
 * Created by Dave on 11/02/2016.
 */
package com.ds.effects.particles.coinshower
{
    import flash.utils.getTimer;

    import starling.display.Sprite;

    public class ParticleScene extends Sprite
    {
        private var particles : Array = new Array();

        /**
         * Constructor function. Creates an instance of <code>ParticleScene</code>.
         * Use this as a container to add particles of type <code>ParticleClip</code>.
         * Starts the animation.
         *
         * The following example show particles shooting up and falling down:
         *
         * @usage
         *
         *  var _pScene = new ParticleScene();
         *  var _pClip : ParticleClip;
         *
         *  var gravity : int = 700;
         *  var numParticles : uint = 0;
         *
         *  var velX : Number;
         *  var velY : Number;
         *
         * 	while (numParticles < 25)
         *	{
		 *		velX = Math.random() * 250 - 75;
		 *		velY = Math.random() * -220 - 300;
		 *
		 * 		// Create a image to use as particle.
		 *		myImg = new Image(myImg);
		 *
		 *		_pClip = new ParticleClip();
		 *		_pClip.addChild(myImg);
		 *
		 *		_pScene.addParticle(_pClip, 100, 100, velX, velY, gravity, 3000, 0.5, Math.random() * 360);
		 *		numParticles ++;
		 *	}
         *
         */
        public function ParticleScene()
        {
            particles = [];
            return;
        }

        /**
         * Adds a particle to the scene.
         *
         * @param	particle		An instance of ParticleClip to add as particle.
         * @param	x				A number that is the x position for the particle.
         * @param	y				A number that is the y position for the particle.
         * @param	velX			A number that is the velocityX for the particle.
         * @param	velY			A number that is the velocityY for the particle.
         * @param	gravity			A int value that represents the gravity to use on the particle.
         * @param	life			A uint that is the time in ms the particle is alive before cleaning it up.
         * @param	scale			A number that is the scale of a particle.
         * @param	rotation		A int value for the rotation for the particle.
         * @param	blendMode		The blendMode for the particle. Default is <code>normal</code>.
         *
         * @return	an instance of ParticleClip.
         */
        public function addParticle(particle : ParticleClip, x : Number, y : Number, velX : Number, velY : Number, gravity : int, life : uint, scale : Number, rotation : int, blendMode : String = "normal") : ParticleClip
        {
            var clip : ParticleClip = particle;
            clip.x = x;
            clip.y = y;
            clip.scaleX = scale;
            clip.scaleY = scale;
            clip.rotation = rotation;
            clip.blendMode = blendMode;
            clip.startX = x;
            clip.startY = y;
            clip.gravity = gravity;
            clip.startTime = getTimer();
            clip.velocityX = velX;
            clip.velocityY = velY;
            clip.life = life;
            particles.push(clip);
            addChild(clip as Sprite);
            return clip;
        }

        /**
         * Clears the particles from the scene.
         */
        public function clear() : void
        {
            var particle : int = particles.length -1;
            while(particle >= 0)
            {
                removeChild(particles[particle]);
                particles.splice(particle, 1);
                particle = particle -1;
            }
            return;
        }

        /**
         * Handles frame updates.
         */
        public function update() : void
        {
            var particle : int = particles.length - 1;

            while(particle >= 0)
            {
                if (particles[particle].update())
                {
                    removeChild(particles[particle]);
                    particles.splice(particle, 1);
                }
                particle = particle - 1;
            }
            return;
        }

    }
}
