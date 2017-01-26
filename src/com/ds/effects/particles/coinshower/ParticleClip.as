/**
 * Created by Dave on 11/02/2016.
 */
package com.ds.effects.particles.coinshower
{
    import flash.utils.getTimer;

    import starling.display.Sprite;

    /**
     * Represents a single particle.
     * Particle Clip to be added to a ParticleScene.
     */
    public class ParticleClip extends Sprite
    {
        public var gravity 		: Number;
        public var startTime	: int;
        public var velocityX	: Number;
        public var velocityY	: Number;
        public var life			: Number;
        public var startX		: Number;
        public var startY		: Number;

        /**
         * Constructor function. Creates an instance of <code>ParticleClip</code>.
         */
        public function ParticleClip()
        {
        }

        /**
         * Updates the particle position.
         */
        public function update() : Boolean
        {
            var time : Number = getTimer() - this.startTime;
            if (time > this.life)
            {
                return true;
            }
            time = time / 1000;
            x = this.startX + this.velocityX * time;
            y = this.startY + this.velocityY * time + 0.5 * this.gravity * (time * time);
            return false;
        }
    }
}
