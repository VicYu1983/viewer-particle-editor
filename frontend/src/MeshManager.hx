import openfl.events.IEventDispatcher;
import threejs.particle.geometry.GeometryCategory;
import threejs.particle.geometry.GeometryManager;
import syncData.SyncDataView;
import haxe.ui.containers.properties.Property;
import haxe.ui.events.UIEvent;
import js.Syntax;
import haxe.ui.containers.TableView;
import openfl.events.EventDispatcher;

typedef MeshNode = {
	id:Int,
	name:String,
	mesh:Dynamic
}

class MeshManager extends EventDispatcher implements IEventDispatcher implements IEditorManager {
	public static final ON_TABLE_MESH_CHANGE = "ON_TABLE_MESH_CHANGE";

	final syncDataView = new SyncDataView();
	final tv:TableView;
	final pro:Property;
	final facade:MainView;
	var id = 0;

	public function new(facade:MainView, tv:TableView, pro:Property) {
		super();
		this.tv = tv;
		this.pro = pro;
		this.facade = facade;

		syncDataView.addView(tv);
		syncDataView.addView(pro);

		clear();

		this.tv.onChange = function(e:UIEvent) {
			dispatchEvent(new EventWithParams(ON_TABLE_MESH_CHANGE, this.tv.selectedItem));
		}
	}

	public function addPlane(uuid:String = "", geometryUuid:String = "", name:String, material:Dynamic, width:Float = 1, height:Float = 1) {
		final geo = Syntax.code("new THREE.PlaneBufferGeometry")(width, height);
		final mesh = Syntax.code("new THREE.Mesh")(geo, material);
		syncDataView.addNode(name, mesh, uuid, {
			uuid: geometryUuid == "" ? MainView.generateUUID() : geometryUuid,
			category: GeometryCategory.PLANE,
			geo: {
				width: width,
				height: height
			}
		});
		return mesh;
	}

	public function addSphere(uuid:String = "", geometryUuid:String = "", name:String, material:Dynamic, radius:Float = 1) {
		final geo = Syntax.code("new THREE.SphereGeometry")(radius);
		final mesh = Syntax.code("new THREE.Mesh")(geo, material);
		syncDataView.addNode(name, mesh, uuid, {
			uuid: geometryUuid == "" ? MainView.generateUUID() : geometryUuid,
			category: GeometryCategory.SPHERE,
			geo: {
				radius: radius
			}
		});
		return mesh;
	}

	public function addBox(uuid:String = "", geometryUuid:String = "", name:String, material:Dynamic, width:Float = 1, height:Float = 1, depth:Float = 1) {
		final geo = Syntax.code("new THREE.BoxGeometry")(width, depth, height);
		final mesh = Syntax.code("new THREE.Mesh")(geo, material);
		syncDataView.addNode(name, mesh, uuid, {
			uuid: geometryUuid == "" ? MainView.generateUUID() : geometryUuid,
			category: GeometryCategory.CUBE,
			geo: {
				width: width,
				height: height,
				depth: depth
			}
		});
		return mesh;
	}

	public function setProMeshById(id:Int) {
		pro.value = syncDataView.getNodeById(id).name;
	}

	public function convertToJsonObject():Dynamic {
		final objs:Array<Dynamic> = [];
		final nodeList = syncDataView.getNodeList();
		for (node in nodeList) {
			final obj:Dynamic = {
				id: node.id,
				name: node.name,
				uuid: node.uuid
			}

			switch (node.item) {
				case null:
					null;
				case _:
					final materialNodeId = facade.getMaterialManager().getSyncDataView().getIdByItem(node.item.material);
					final materialNode = facade.getMaterialManager().getSyncDataView().getNodeById(materialNodeId);
					obj.extra = {
						geometry: node.extra,
						material: {
							uuid: materialNode.uuid
						}
					}
			}

			objs.push(obj);
		}
		return objs;
	}

	public function getSyncDataView():SyncDataView {
		return syncDataView;
	}

	public function clear():Void {
		syncDataView.clear();
		syncDataView.addNode("無", null);
	}
}
