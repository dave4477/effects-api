/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.filtered
{
    import flash.desktop.NativeApplication;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class EffectsManager extends EventDispatcher
    {
        public static const EFFECT_STOPPED : String = "EffectsManager.EFFECT_STOPPED";

        private static const TRESHOLD : int = 70;

        private static var _instance : EffectsManager;
        private static var _zeroPoint : Point = new Point();
        private static var _widthPoint : Point = new Point();
        private static var _passedTime : Number = 0;

        private var _isLost:Boolean;
        private var _effects : Vector.<AbstractEffect>;
        private var _pausedEffects : Vector.<AbstractEffect>;
        private var _effectsEnabled : Boolean = true;
        private var _globalPos : Point = new Point();
        private var _currentPoint : Point = new Point();
        private var _target : DisplayObject;
        private var _sw : int;

        public function EffectsManager()
        {
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onFocusRestored);
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onFocusLost);

            _effects = new Vector.<AbstractEffect>();
            _pausedEffects = new Vector.<AbstractEffect>();
            _sw = Starling.current.stage.stageWidth;
        }

        private function onFocusLost(e:flash.events.Event):void
        {
            _isLost = true;
        }
        private function onFocusRestored(e:flash.events.Event):void
        {
            _isLost = false;
        }
        public static function getInstance() : EffectsManager
        {
            if (!_instance)
            {
                _instance = new EffectsManager();
            }
            return _instance;
        }

        public function startTicker() : void
        {
            if (_effects.length > 0 || _pausedEffects.length > 0)
            {
                resumeAllEffects();
            }
            else
            {
                stopAllEffects();
            }
        }

        /**
         * Add a filtered effect to the effectsManager.
         * @param effect
         */
        public function addEffect(effect : AbstractEffect) : void
        {
            if (_isLost) return;
            if (effect.autoStart)
            {
                _effects.push(effect);
                effect.init();
            }
            else
            {
                _pausedEffects.push(effect);
            }
        }

        /**
         * Returns the passed time since the last frame in seconds.
         * @return Number.
         */
        public static function get passedTime() : Number
        {
            return _passedTime;
        }

        /**
         * Stops all effects.
         */
        public function stopAllEffects() : void
        {
            Starling.current.stage.removeEventListener(starling.events.Event.ENTER_FRAME, onUpdate);
            for (var i : int = 0; i < _effects.length; i++)
            {
                _effects[i].stop();
            }
        }

        /**
         * Stops an effect for a given target (DisplayObject).
         *
         * @param name  The name of the target.
         */
        public function stopEffectForTarget(name : String, isMarkedForDeletion : Boolean = false) : void
        {
            for (var i : int = 0; i < _effects.length; i++)
            {
                if (_effects[i].target.name == name)
                {
                    if (!isMarkedForDeletion)
                    {
                        _pausedEffects.push(_effects[i]);
                    }
                    _effects[i].stop();
                    var spliced : Vector.<AbstractEffect> = _effects.splice(i, 1);
                    dispatchEventWith(EFFECT_STOPPED, false, {effect: spliced[0]});
                    spliced = null;
                    break;
                }
            }
            if (isMarkedForDeletion)
            {
                for (var j : int = 0; j < _pausedEffects.length; j++)
                {
                    if (_pausedEffects[j].target.name == name)
                    {
                        _pausedEffects[j].destroy();
                        _pausedEffects.splice(j, 1);
                    }
                }
            }
        }

        /**
         * Starts an effect for a given target.
         *
         * @param name  A String representing the name of the target.
         * @param delay The time in ms to delay before the animation starts.
         */
        public function startEffectForTarget(name : String, delay : int = 0) : void
        {
            setTimeout(internalStartEffectForTarget, delay, name);
        }

        private function internalStartEffectForTarget(name : String) : void
        {
            for (var i:int = 0; i < _pausedEffects.length; i++)
            {
                if (_pausedEffects[i].target.name == name)
                {
                    var spliced : AbstractEffect = _pausedEffects.splice(i,1)[0];
                    spliced.init();
                    _effects.push(spliced);
                    break;
                }
            }
        }

        /**
         * Resumes all effects.
         */
        public function resumeAllEffects() : void
        {
            // Always remove just in case it does exist and resume was called while it's already running.
            Starling.current.stage.removeEventListener(starling.events.Event.ENTER_FRAME, onUpdate);
            Starling.current.stage.addEventListener(starling.events.Event.ENTER_FRAME, onUpdate);
        }

        /**
         * Deletes an effect of a given type.
         * @param type  EffectType.TYPE
         */
        public function deleteEffectsOfType(type : String) : void
        {
            stopAllEffects();

            for (var i : int = 0; i < _effects.length; i++)
            {
                if (_effects[i].effectName == type)
                {
                    _effects[i].destroy();
                    _effects.splice(i, 1);
                    deleteEffectsOfType(type);
                    break;
                }
            }
            resumeAllEffects();
        }

        /**
         * Destroys all effects.
         */
        public function destroyAllEffects() : void
        {
            stopAllEffects();

            for (var i : int = 0; i < _effects.length; i++)
            {
                if (_effects[i])
                {
                    _effects[i].destroy();
                    _effects.splice(i, 1);
                    destroyAllEffects();
                }
            }
        }

        /**
         * Returns whether the effects are enabled or disabled.
         *
         * @return Boolean
         */
        public function get effectsEnabled() : Boolean
        {
            return _effectsEnabled;
        }

        /**
         * Disables or enables all effects without removing them.
         * Like an override.
         *
         * @param value Boolean
         */
        public function set effectsEnabled(value : Boolean) : void
        {
            _effectsEnabled = value;
            var effectsLength : int = _effects.length;

            var i:int;

            if (value == false)
            {
                for (i = 0; i < effectsLength; i++)
                {
                    _effects[i].stop();
                }
            }
            else
            {
                for (i = 0; i < effectsLength; i++)
                {
                    _effects[i].init();
                }
            }
        }

        public function get effects() : Vector.<AbstractEffect>
        {
            return _effects;
        }

        public function overrideAttribute(targetName : String, attribute : String, value : Number) : void
        {
            var effect : AbstractEffect = getEffectForTarget(targetName);
            if (effect) effect.overrideAttribute(attribute, value);
        }

        public function resetAttribute(targetName : String, attribute : String) : void
        {
            var effect : AbstractEffect = getEffectForTarget(targetName);
            if (effect) effect.resetAttribute(attribute);
        }

        public function resetAllAttributes(targetName : String) : void
        {
            var effect : AbstractEffect = getEffectForTarget(targetName);
            if (effect) effect.resetAllAttributes();
        }

        //////////////////////////////////////////////////////
        // Private
        //////////////////////////////////////////////////////

        private function getEffectForTarget(name : String) : AbstractEffect
        {
            var i : int;
            for (i = 0; i < _effects.length; i++)
            {
                if (_effects[i].target.name == name)
                {
                    return _effects[i];
                }
            }
            for (i = 0; i < _pausedEffects.length; i++)
            {
                if (_pausedEffects[i].target.name == name)
                {
                    return _pausedEffects[i];
                }
            }
            return null;
        }

        // Updater.
        private function onUpdate(e : EnterFrameEvent) : void
        {
            if (_isLost) return;

            _passedTime = e.passedTime;

            updatePersistentEffects();

            if (!_effectsEnabled)
            {
                return;
            }

            for (var i : int = 0; i < _effects.length; i++)
            {
                _target = _effects[i].target;

                if(_target && _effects[i].autoStart)
                {
                    _currentPoint = _target.localToGlobal(_zeroPoint, _globalPos);
                    _widthPoint = _target.localToGlobal(new Point(_target.width,0));

                    if ((_currentPoint.x < _sw - TRESHOLD) && (_currentPoint.x + _widthPoint.x > TRESHOLD))
                    {
                        _effects[i].draw();
                    }
                    else
                    {
                        _effects[i].stop();
                    }
                }
            }
        }

        public function get isLost():Boolean
        {
            return _isLost;
        }

        private function updatePersistentEffects() : void
        {
            for (var i : int = 0; i < _effects.length; i++)
            {
                if (!_effects[i].autoStart)
                {
                    _effects[i].draw();
                }
            }
        }
    }
}