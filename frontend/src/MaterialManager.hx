import openfl.events.IEventDispatcher;
import threejs.particle.Manager;
import syncData.SyncNode;
import threejs.particle.shader.ShaderCategory;
import syncData.SyncDataView;
import threejs.shaders.ParticleSpriteShader;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.properties.Property;
import js.Syntax;
import threejs.shaders.SpriteShader;
import threejs.shaders.BasicShader;
import haxe.ui.containers.TableView;
import threejs.shaders.ShaderTool;
import threejs.shaders.IShader;
import openfl.events.EventDispatcher;

class MaterialManager extends EventDispatcher implements IEventDispatcher implements IEditorManager {
	// public static final ON_MATERIAL_ADD = "ON_MATERIAL_ADD";
	public static final ON_DD_MATERIAL_CHANGE = "ON_DD_MATERIAL_CHANGE";
	public static final ON_TV_MATERIAL_CLICK = "ON_TV_MATERIAL_CLICK";

	final shaderList:Array<IShader>;
	final tv_materialList:TableView;
	final pro_geometryMaterialSetting:Property;

	final syncDataView = new SyncDataView();

	public function new(tv_materialList:TableView, pro_geometryMaterialSetting:Property) {
		super();
		this.tv_materialList = tv_materialList;
		this.pro_geometryMaterialSetting = pro_geometryMaterialSetting;

		syncDataView.addView(tv_materialList);
		syncDataView.addView(pro_geometryMaterialSetting);

		shaderList = [new BasicShader(), new SpriteShader(), new ParticleSpriteShader()];

		tv_materialList.onClick = function(e:UIEvent) {
			dispatchEvent(new EventWithParams(ON_TV_MATERIAL_CLICK, tv_materialList.selectedItem));
		}

		pro_geometryMaterialSetting.onChange = function(e:UIEvent) {
			dispatchEvent(new EventWithParams(ON_DD_MATERIAL_CHANGE, pro_geometryMaterialSetting.value));
		}
	}

	public function addMeshPhongMaterial(uuid:String = "", shaderUuid:String = ""):Dynamic {
		final mat = Syntax.code("new THREE.MeshPhongMaterial")();
		syncDataView.addNode("光照", mat, uuid, {uuid: shaderUuid == "" ? MainView.generateUUID() : shaderUuid, category: ShaderCategory.PHONG_SHADER});
		return mat;
	}

	public function addBasicMaterial(uuid:String = "", shaderUuid:String = "", blending:Int = 0, transparent:Bool = false, depthWrite:Bool = true,
			side:Int = 0):Dynamic {
		final mat = ShaderTool.getMaterial(null, shaderList[0], blending, transparent, depthWrite, side);
		syncDataView.addNode("純色", mat, uuid, {uuid: shaderUuid == "" ? MainView.generateUUID() : shaderUuid, category: ShaderCategory.BASIC_SHADER});
		return mat;
	}

	public function addBillBoardMaterial(uuid:String = "", shaderUuid:String = "", blending:Int = 0, transparent:Bool = false, depthWrite:Bool = true,
			side:Int = 0):Dynamic {
		final mat = ShaderTool.getMaterial(null, shaderList[1], blending, transparent, depthWrite, side);
		syncDataView.addNode("廣告版", mat, uuid, {uuid: shaderUuid == "" ? MainView.generateUUID() : shaderUuid, category: ShaderCategory.SPRITE_SHADER});
		return mat;
	}

	public function addParticleSpriteShader(uuid:String = "", shaderUuid:String = "", blending:Int = 0, transparent:Bool = false, depthWrite:Bool = true,
			side:Int = 0):Dynamic {
		final mat = ShaderTool.getMaterial(null, shaderList[2], blending, transparent, depthWrite, side);
		syncDataView.addNode("粒子廣告版", mat, uuid,
			{uuid: shaderUuid == "" ? MainView.generateUUID() : shaderUuid, category: ShaderCategory.PARTICLE_SPRITE_SHADER});
		return mat;
	}

	public function setDdMaterialTo(id:Int) {
		pro_geometryMaterialSetting.value = syncDataView.getNodeById(id).name;
	}

	public function convertToJsonObject():Dynamic {
		final objs:Array<Dynamic> = [];
		final nodeList = syncDataView.getNodeList();
		for (node in nodeList) {
			final shaderModel:Dynamic = switch (node.extra.category) {
				case ShaderCategory.BASIC_SHADER:
					{};
				case ShaderCategory.PHONG_SHADER:
					{
						color: node.item.color,
						specular: node.item.specular,
						emissive: node.item.emissive
					};
				case ShaderCategory.SPRITE_SHADER:
					{
						baseColor: [
							node.item.uniforms.baseColor.value.x,
							node.item.uniforms.baseColor.value.y,
							node.item.uniforms.baseColor.value.z
						]
					};
				case ShaderCategory.PARTICLE_SPRITE_SHADER:
					{
						baseColor: [
							node.item.uniforms.baseColor.value.x,
							node.item.uniforms.baseColor.value.y,
							node.item.uniforms.baseColor.value.z
						],
						usingNoise: node.item.uniforms.usingNoise.value,
						usingMask: node.item.uniforms.usingMask.value,
						usingTex: node.item.uniforms.usingTex.value,
					};
				case _: {};
			}

			shaderModel.uuid = node.extra.uuid;
			shaderModel.category = node.extra.category;

			shaderModel.blending = node.item.blending;
			shaderModel.side = node.item.side;
			shaderModel.depthWrite = node.item.depthWrite;
			shaderModel.transparent = node.item.transparent;
			shaderModel.opacity = node.item.opacity;

			objs.push({
				id: node.id,
				name: node.name,
				uuid: node.uuid,
				extra: {
					shader: shaderModel
				}
			});
		}
		return objs;
	}

	public function getSyncDataView():SyncDataView {
		return syncDataView;
	}

	public function clear():Void{
		syncDataView.clear();
	}
}
