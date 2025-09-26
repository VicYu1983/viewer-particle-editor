package component;

import haxe.ui.events.UIEvent;
import haxe.ui.containers.HBox;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/custom_slider_view.xml"))
class CustomView extends HBox {
	public static final ON_VALUE_CHANGE = "ON_VALUE_CHANGE";
	public static final ON_LIMIT_CHANGE = "ON_LIMIT_CHANGE";

	public var key(default, default):ParticleProperties.Name;
	public var name(get, set):String;
	public var minPos(get, set):Float;
	public var minMin(get, set):Float;
	public var minMax(get, set):Float;
	public var maxPos(get, set):Float;
	public var maxMin(get, set):Float;
	public var maxMax(get, set):Float;
	public var currentValue(get, set):Float;

	private var lastValue:Float = 0;

	public function new() {
		super();

		sdr_value.onChange = function(e) {
			onValueChange();
		}

		num_min.onMouseOut = function(e) {
			final min = num_min.pos;
			final max = num_max.pos;
			if (lastValue < min) {
				sdr_value.value = 0;
				onValueChange();
			}
			sdr_value.value = (lastValue - min) / (max - min) * 100;
			dispatch(new UIEvent(ON_LIMIT_CHANGE));
		}

		num_max.onMouseOut = function(e) {
			final min = num_min.pos;
			final max = num_max.pos;
			if (lastValue > max) {
				sdr_value.value = 100;
				onValueChange();
			}
			sdr_value.value = (lastValue - min) / (max - min) * 100;
			dispatch(new UIEvent(ON_LIMIT_CHANGE));
		}
	}

	function onValueChange() {
		final pos = sdr_value.value;
		final min = num_min.pos;
		final max = num_max.pos;
		final value = (max - min) * pos * 0.01 + min;
		lastValue = value;

		sdr_value.tooltip = Math.round(lastValue * 100) / 100;
		dispatch(new UIEvent(ON_VALUE_CHANGE, false, value));
	}

	function set_name(value:String):String {
		txt_title.text = value;
		return txt_title.text;
	}

	function get_name():String {
		return txt_title.text;
	}

	function set_minMin(value:Float):Float {
		num_min.min = value;
		return value;
	}

	function get_minMin():Float {
		return num_min.min;
	}

	function set_minMax(value:Float):Float {
		num_min.max = value;
		return value;
	}

	function get_minMax():Float {
		return num_min.max;
	}

	function set_maxMin(value:Float):Float {
		num_max.min = value;
		return value;
	}

	function get_maxMin():Float {
		return num_max.min;
	}

	function set_maxMax(value:Float):Float {
		num_max.max = value;
		return value;
	}

	function get_maxMax():Float {
		return num_max.max;
	}

	function set_minPos(value:Float):Float {
		num_min.pos = value;
		return value;
	}

	function get_minPos():Float {
		return num_min.pos;
	}

	function set_maxPos(value:Float):Float {
		num_max.pos = value;
		return value;
	}

	function get_maxPos():Float {
		return num_max.pos;
	}

	function set_currentValue(value:Float):Float {
		final min = num_min.pos;
		final max = num_max.pos;
		sdr_value.value = (value - min) / (max - min) * 100;
		lastValue = value;
		return sdr_value.value;
	}

	function get_currentValue():Float {
		return lastValue;
	}
}
