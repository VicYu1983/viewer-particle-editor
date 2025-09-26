import openfl.events.IEventDispatcher;
import threejs.particle.system.ParticlePool;
import threejs.particle.system.Emitter;
import threejs.particle.system.Particle;
import threejs.particle.system.IParticle;
import threejs.particle.system.ParticleSystem;
import syncData.SyncDataView;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.properties.Property;
import openfl.events.EventDispatcher;
import js.Syntax;
import haxe.ui.containers.TreeViewNode;
import threejs.shaders.ShaderTool;
import haxe.ui.containers.TreeView;

class ParticleManager extends EventDispatcher implements IEventDispatcher implements IEditorManager {
	public static final ON_CREATE_NODE = "ON_CREATE_NODE";
	public static final ON_TREE_NODE_CLICK = "ON_TREE_NODE_CLICK";
	public static final ON_PRO_PARENT_CHANGE = "ON_PRO_PARENT_CHANGE";

	final ps = ParticleSystem.getInstance();
	final tv_particleList:TreeView = null;
	final pro_pParent:Property = null;
	final particleTreeMap:Map<TreeViewNode, IParticle> = new Map();
	final rootNode:TreeViewNode = null;
	final facade:MainView = null;
	final syncDataView = new SyncDataView();

	var lastParticle:IParticle = null;

	public function new(facade:MainView, tv_particleList:TreeView, pro_pParent:Property) {
		super();

		this.tv_particleList = tv_particleList;
		this.pro_pParent = pro_pParent;
		this.facade = facade;

		syncDataView.addView(pro_pParent);

		rootNode = tv_particleList.addNode({text: "場景", icon: "haxeui-core/styles/default/haxeui_tiny.png"});
		rootNode.expanded = true;
		rootNode.onClick = function(e) {
			dispatchEvent(new EventWithParams(ON_TREE_NODE_CLICK, {node: rootNode, particle: null}));
		}

		syncDataView.addNode("無", null);

		// pro_pParent.dataSource.add({
		// 	id: -1,
		// 	text: "無",
		// 	particle: null
		// });

		pro_pParent.onChange = function(e:UIEvent) {
			dispatchEvent(new EventWithParams(ON_PRO_PARENT_CHANGE, pro_pParent.value));
		}

		// var child = root1.addNode({text: "發射器", icon: "haxeui-core/styles/default/haxeui_tiny.png"});
		// var node = child.addNode({text: "粒子", icon: "haxeui-core/styles/default/haxeui_tiny.png"});

		// tv_particleList.onClick = function (e) {
		// 	Syntax.code("console.log")(e);
		// }

		// child.onClick = function(e) {
		// 	Syntax.code("console.log")(e.target.text);
		// }

		// node.onClick = function(e) {
		// 	e.cancel();
		// 	Syntax.code("console.log")(e.target.text);
		// }
	}

	public function getParticleSystem() {
		return ps;
	}

	public function getNodeList() {
		return particleTreeMap.keys();
	}

	public function createParticle(uuid:String = "", mesh:Dynamic = null, pool:Bool = true):IParticle {
		final p = new Particle(mesh, pool ? new ParticlePool() : null);
		p.name = "particle";
		p.uuid = uuid == "" ? MainView.generateUUID() : uuid;
		return p;
	}

	public function createEmitter(uuid:String = "", mesh:Dynamic = null, pool:Bool = true):IParticle {
		final e = new Emitter(mesh, pool ? new ParticlePool() : null);
		e.name = "emitter";
		e.uuid = uuid == "" ? MainView.generateUUID() : uuid;
		syncDataView.addNode(e.name, e, uuid);
		return e;
	}

	public function addEmitter(emitter:IParticle) {
		getParticleSystem().addEmitter(emitter);
		syncTreeNode();
	}

	public function setParticle(emitter:IParticle, particle:IParticle) {
		emitter.setParticle(particle);
		syncTreeNode();
	}

	public function getParticleByNode(node:TreeViewNode) {
		return particleTreeMap.get(node);
	}

	public function getNodeByParticle(particle:IParticle):TreeViewNode {
		final keys = particleTreeMap.keys();
		while (keys.hasNext()) {
			final node = keys.next();
			if (particleTreeMap.get(node) == particle) {
				return node;
			}
		}
		return null;
	}

	public function restart() {
		getParticleSystem().playAll();
	}

	public function getTreeNodeFromParticle(p:IParticle):TreeViewNode {
		final keys = particleTreeMap.keys();
		while (keys.hasNext()) {
			final node = keys.next();
			if (particleTreeMap.get(node) == p) {
				return node;
			}
		}
		return null;
	}

	public function getParticleFromUuid(uuid:String):IParticle {
		final keys = particleTreeMap.keys();
		while (keys.hasNext()) {
			final node = keys.next();
			final particle = particleTreeMap.get(node);
			if (particle == null) {
				// trace("這邊有時會有沒有刪除乾净的物件。有時間來檢查", {warning: true});
				trace("這邊有時會有沒有刪除乾净的物件。有時間來檢查");
				return null;
			}
			if (particle.uuid == uuid) {
				return particle;
			}
		}
		return null;
	}

	public function syncTreeNode() {
		rootNode.clearNodes();
		particleTreeMap.clear();

		var onNodeClick = function(e) {
			e.cancel();

			final tv = cast(e.target, TreeViewNode);
			if (tv != null) {
				lastParticle = getParticleByNode(tv);
				dispatchEvent(new EventWithParams(ON_TREE_NODE_CLICK, {node: tv, particle: lastParticle}));
			}
		};

		final emitters = getParticleSystem().getEmitters();
		for (index => emitter in emitters) {
			var current = emitter;
			var currentParentNode = rootNode.addNode({
				text: current.name,
				icon: "haxeui-core/styles/default/haxeui_tiny.png"
			});
			currentParentNode.onClick = onNodeClick;
			particleTreeMap.set(currentParentNode, current);
			while (current.child != null) {
				current = current.child;
				var currentNode = currentParentNode.addNode({
					text: current.name,
					icon: "haxeui-core/styles/default/haxeui_tiny.png"
				});
				currentNode.onClick = onNodeClick;
				particleTreeMap.set(currentNode, current);

				currentParentNode.expanded = true;
				currentParentNode = currentNode;
			}
		}

		if (lastParticle != null) {
			tv_particleList.selectedNode = getNodeByParticle(lastParticle);
		}
	}

	public function removeParticle(particle:IParticle) {
		syncDataView.removeNodeByItem(particle);
		getParticleSystem().removeEmitter(particle);
		syncTreeNode();
	}

	public function convertToJsonObject():Dynamic {
		final emitters = [];
		// 把mesh對象轉爲uuid
		for (e in getParticleSystem().getEmitters()) {
			final jsonObj = e.convertToJsonObject();
			if (jsonObj.proxy != null) {
				final proxyId = facade.getMeshManager().getSyncDataView().getIdByItem(jsonObj.proxy);
				final proxyNode = facade.getMeshManager().getSyncDataView().getNodeById(proxyId);
				jsonObj.proxy = proxyNode.uuid;
			}

			var currentChild:Dynamic = jsonObj.child;
			while (currentChild != null) {
				if (currentChild.proxy != null) {
					final proxyId = facade.getMeshManager().getSyncDataView().getIdByItem(currentChild.proxy);
					final proxyNode = facade.getMeshManager().getSyncDataView().getNodeById(proxyId);
					currentChild.proxy = proxyNode.uuid;
				}
				currentChild = currentChild.child;
			}
			emitters.push(jsonObj);
		}

		return emitters;
	}

	public function getSyncDataView():SyncDataView {
		return syncDataView;
	}

	public function clear():Void {
		syncDataView.clear();
		getParticleSystem().clearAllEmitter();
		getParticleSystem().clear();
		syncTreeNode();
		// clearPool();
	}

	// public function clearPool() {
	// 	final nodes = particleTreeMap.keys();
	// 	while (nodes.hasNext()) {
	// 		final node = nodes.next();
	// 		final particle = particleTreeMap.get(node);

	// 		// particle.clearPool();
	// 	}
	// }
}
