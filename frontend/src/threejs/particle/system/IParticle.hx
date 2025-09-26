package threejs.particle.system;

import threejs.particle.system.forces.IForce;
import openfl.events.IEventDispatcher;

typedef Spray = {
	var horizonAngle:Float;
	var horizonRandom:Float;
	var verticalAngle:Float;
	var verticalRandom:Float;
	var force:Float;
	var rate:Float;
};

interface IParticle extends IEventDispatcher {
	var uuid:String;
	var id:Int;
	var name:String;
	var pool:ParticlePool;
	var parent:IParticle;
	var child:IParticle;
	var spray:Spray;
	var age:Float;
	var deadAge:Float;
	var randomDeadAge:Float;
	var proxy:Dynamic;
	var forces:Array<IForce>;
	var acceleration:Dynamic;
	var velocity:Dynamic;
	var mass:Float;
	var rotate:Float;
	var rotateSpeed:Float;
	var randomRotate:Float;
	var randomPosition:Dynamic;
	var size:Float;
	var randomSize:Float;
	var sizeIn:Float;
	var sizeOut:Float;
	var enabledRotateAlongSpeed:Bool;

	function setParticle(particle:IParticle):Void;
	function addForce(force:Dynamic):Void;
	function applyForce(force:Dynamic):Void;
	function setPosition(x:Float, y:Float, z:Float):Void;
	function getPosition():Dynamic;
	function setRotation(x:Float, y:Float, z:Float):Void;
	function getRotation():Dynamic;
	function setScale(x:Float, y:Float, z:Float):Void;
	function getScale():Dynamic;
	function update(delta:Float):Void;
	function clone():IParticle;
	function convertToJsonObject():Dynamic;
}
