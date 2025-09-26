package;

import dialog.SaveDialog;
import threejs.particle.system.ParticleSystem;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialog.DialogEvent;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.notifications.NotificationManager;
import js.Browser;
import haxe.ui.util.Properties;
import threejs.particle.geometry.GeometryCategory;
import haxe.Json;
import js.html.FileReader;
import threejs.particle.Manager;
import threejs.particle.system.Emitter;
import threejs.particle.system.IParticle;
import js.html.Blob;
import component.CustomView;
import haxe.ui.containers.TreeViewNode;
import haxe.Timer;
import haxe.ui.events.UIEvent;
import js.Syntax;
import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import threejs.particle.shader.ShaderCategory;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main_view.xml"))
class MainView extends VBox {
	final viewer:Dynamic;
	final particleManager:ParticleManager;
	final materialManager:MaterialManager;
	final meshManager:MeshManager;
	final fps = 30.0;
	final timeForTick = 0;
	final tList:Array<Dynamic> = [];
	final prosList:Map<ParticleProperties.Name, CustomView> = [];
	final manager = Manager.getInstance();

	var time = 0.0;
	var isViewerReady = false;
	var editNode:TreeViewNode = null;
	var editParticle:IParticle = null;
	var editGeometry:Dynamic = null;
	var editMaterial:Dynamic = null;
	var lastLoadingModel:String = "";

	final invisibleMaterial = Syntax.code("new THREE.MeshBasicMaterial")({transparent: true, opacity: 0});
	final oldMaterial:Array<Dynamic> = [];

	public function new() {
		super();

		timeForTick = Std.int(1000 / fps);

		// dd_createMaterialList.selectedIndex = 0;

		// var spray:Spray;
		// var forces:Array<IForce>;
		// var enabledRotateAlongSpeed:Bool;

		// final propertieList:Array<Array<Dynamic>> = [
		// 	[ParticleProperties.Name.DEAD, 1, 0.1, 100, 10, 0.15, 100],
		// 	["生命隨機", 1, 0.1, 100, 10, 0.15, 100],
		// 	["加速度x", 1, 0.1, 100, 10, 0.15, 100],
		// 	["加速度y", 1, 0.1, 100, 10, 0.15, 100],
		// 	["加速度z", 1, 0.1, 100, 10, 0.15, 100],
		// 	["速度x", 1, 0.1, 100, 10, 0.15, 100],
		// 	["速度y", 1, 0.1, 100, 10, 0.15, 100],
		// 	["速度z", 1, 0.1, 100, 10, 0.15, 100],
		// 	["質量", 1, 0.1, 100, 10, 0.15, 100],
		// 	["角度", 1, 0.1, 100, 10, 0.15, 100],
		// 	["角度隨機", 1, 0.1, 100, 10, 0.15, 100],
		// 	["旋轉速度", 1, 0.1, 100, 10, 0.15, 100],
		// 	["位置隨機x", 1, 0.1, 100, 10, 0.15, 100],
		// 	["位置隨機y", 1, 0.1, 100, 10, 0.15, 100],
		// 	["位置隨機z", 1, 0.1, 100, 10, 0.15, 100],
		// 	["縮放", 1, 0.1, 100, 10, 0.15, 100],
		// 	["縮放隨機", 1, 0.1, 100, 10, 0.15, 100],
		// 	["放大時間", 1, 0.1, 100, 10, 0.15, 100],
		// 	["縮小時間", 1, 0.1, 100, 10, 0.15, 100],
		// ];

		final propertieList:Array<Array<Dynamic>> = [
			[ParticleProperties.Name.HORIZON_ANGLE, -180, 180, 0.15, 300],
			[ParticleProperties.Name.HORIZON_RANDOM, 0, 360, 0.15, 300],
			[ParticleProperties.Name.VERTICAL_ANGLE, -180, 180, 0.15, 300],
			[ParticleProperties.Name.VERTICAL_RANDOM, 0, 180, 0.15, 300],
			[ParticleProperties.Name.FORCE, .01, 10, 0.15, 300],
			[ParticleProperties.Name.RATE, .01, 10, 0.15, 300],
			[ParticleProperties.Name.POSITION_X, -10, 10, 0.15, 100],
			[ParticleProperties.Name.POSITION_Y, -10, 10, 0.15, 100],
			[ParticleProperties.Name.POSITION_Z, -10, 10, 0.15, 100],

			[ParticleProperties.Name.DEAD, .01, 10, 0.15, 300],
			[ParticleProperties.Name.DEAD_RANDOM, 0, 3, 100, 100],
			[ParticleProperties.Name.ACCELERATION_X, -.1, .1, 0.15, 100],
			[ParticleProperties.Name.ACCELERATION_Y, -.1, .1, 0.15, 100],
			[ParticleProperties.Name.ACCELERATION_Z, -.1, .1, 0.15, 100],
			[ParticleProperties.Name.VELOCITY_X, -1, 1, 0.15, 100],
			[ParticleProperties.Name.VELOCITY_Y, -1, 1, 0.15, 100],
			[ParticleProperties.Name.VELOCITY_Z, -1, 1, 0.15, 100],
			[ParticleProperties.Name.MASS, 0.01, 100, 0.15, 100],
			[ParticleProperties.Name.ANGLE, -180, 180, 0.15, 100],
			[ParticleProperties.Name.ANGLE_RANDOM, -180, 180, 0.15, 100],
			[ParticleProperties.Name.ROTATION_SPEED, -1, 1, 0.15, 100],
			[ParticleProperties.Name.POSITION_RANDOM_X, 0, 5, 0.15, 100],
			[ParticleProperties.Name.POSITION_RANDOM_Y, 0, 5, 0.15, 100],
			[ParticleProperties.Name.POSITION_RANDOM_Z, 0, 5, 0.15, 100],
			[ParticleProperties.Name.SCALE, 0, 10, 0.15, 100],
			[ParticleProperties.Name.SCALE_RANDOM, 0, 3, 0.15, 100],
			[ParticleProperties.Name.GROWTH_TIME, 0, 3, 0.15, 100],
			[ParticleProperties.Name.SHRINK_TIME, 0, 3, 0.15, 100],
		];

		for (pro in propertieList) {
			final customView = new CustomView();
			customView.key = pro[0];
			customView.name = ParticleProperties.translate(pro[0]);
			customView.minPos = pro[1];
			// customView.minMin = pro[1];
			// customView.minMax = pro[2];
			customView.maxPos = pro[2];
			// customView.maxMin = pro[1];
			// customView.maxMax = pro[2];
			prosList.set(pro[0], customView);
			customView.registerEvent(CustomView.ON_VALUE_CHANGE, onCustomViewValueChange);
			customView.registerEvent(CustomView.ON_LIMIT_CHANGE, onCustomViewLimitChange);
			box_pProperties.addComponent(customView);
		}

		particleManager = new ParticleManager(this, tv_particleList, pro_pParent);
		particleManager.addEventListener(ParticleManager.ON_TREE_NODE_CLICK, onPMSelectNode);
		particleManager.addEventListener(ParticleManager.ON_PRO_PARENT_CHANGE, onPMParentChange);

		viewer = Syntax.code("new Autodesk.Viewing.Viewer3D")(viewerDiv.element);

		materialManager = new MaterialManager(tv_materialList, pro_gMaterial);
		materialManager.addEventListener(MaterialManager.ON_DD_MATERIAL_CHANGE, onProGMaterialChange);
		materialManager.addEventListener(MaterialManager.ON_TV_MATERIAL_CLICK, onTvMaterialListClick);

		meshManager = new MeshManager(this, tv_geometryList, pro_pGeometry);
		meshManager.addEventListener(MeshManager.ON_TABLE_MESH_CHANGE, onTvMeshChange);

		final t = new Timer(timeForTick);
		t.run = onTick;

		// 添加点击事件监听器
		// tv_geometryList.addEventListener(new EventListener(function(event) {
		// 	var target = event.target; // 获取被点击的item
		// 	// 在这里处理点击事件
		// 	trace("Item clicked: " + target.text); // 输出被点击item的文本内容
		// }));

		// tv_geometryList.onClick = function(e){
		// 	var target = e.target; // 获取被点击的item

		// 	Main.log(target);
		// 	// 在这里处理点击事件
		// 	// trace("Item clicked: " + target.text); // 输出被点击item的文本内容
		// }

		box_pProperties.disabled = true;
		pg_geometrySetting.disabled = true;
		pg_shaderSetting.disabled = true;

		Browser.document.addEventListener("keydown", onKeyDown);
	}

	private function onKeyDown(event:js.html.KeyboardEvent) {
		if (event.altKey && event.key == "r") {
			particleManager.restart();
		}
	}

	private function onCustomViewLimitChange(e:UIEvent) {
		if (editParticle == null)
			return;
		ParticleProperties.setInstance(editParticle, prosList);
	}

	private function onCustomViewValueChange(e:UIEvent) {
		if (editParticle == null)
			return;

		final key:ParticleProperties.Name = cast(e.target, CustomView).key;
		final value = prosList.get(key).currentValue;
		switch (key) {
			case ParticleProperties.Name.DEAD:
				editParticle.deadAge = value;
			case ParticleProperties.Name.DEAD_RANDOM:
				editParticle.randomDeadAge = value;
			case ParticleProperties.Name.ACCELERATION_X:
				editParticle.acceleration.x = value;
			case ParticleProperties.Name.ACCELERATION_Y:
				editParticle.acceleration.y = value;
			case ParticleProperties.Name.ACCELERATION_Z:
				editParticle.acceleration.z = value;
			case ParticleProperties.Name.VELOCITY_X:
				editParticle.velocity.x = value;
			case ParticleProperties.Name.VELOCITY_Y:
				editParticle.velocity.y = value;
			case ParticleProperties.Name.VELOCITY_Z:
				editParticle.velocity.z = value;
			case ParticleProperties.Name.MASS:
				editParticle.mass = value;
			case ParticleProperties.Name.ANGLE:
				editParticle.rotate = value / 180 * Math.PI;
			case ParticleProperties.Name.ANGLE_RANDOM:
				editParticle.randomRotate = value / 180 * Math.PI;
			case ParticleProperties.Name.ROTATION_SPEED:
				editParticle.rotateSpeed = value;
			case ParticleProperties.Name.POSITION_RANDOM_X:
				editParticle.randomPosition.x = value;
			case ParticleProperties.Name.POSITION_RANDOM_Y:
				editParticle.randomPosition.y = value;
			case ParticleProperties.Name.POSITION_RANDOM_Z:
				editParticle.randomPosition.z = value;
			case ParticleProperties.Name.SCALE:
				editParticle.size = value;
			case ParticleProperties.Name.SCALE_RANDOM:
				editParticle.randomSize = value;
			case ParticleProperties.Name.GROWTH_TIME:
				editParticle.sizeIn = value;
			case ParticleProperties.Name.SHRINK_TIME:
				editParticle.sizeOut = value;
			case ParticleProperties.Name.POSITION_X, ParticleProperties.Name.POSITION_Y, ParticleProperties.Name.POSITION_Z:
				final x = prosList.get(ParticleProperties.Name.POSITION_X).currentValue;
				final y = prosList.get(ParticleProperties.Name.POSITION_Y).currentValue;
				final z = prosList.get(ParticleProperties.Name.POSITION_Z).currentValue;
				editParticle.setPosition(x, y, z);
			case ParticleProperties.Name.HORIZON_ANGLE:
				editParticle.spray.horizonAngle = value / 180 * Math.PI;
				particleManager.restart();
			case ParticleProperties.Name.HORIZON_RANDOM:
				editParticle.spray.horizonRandom = value / 180 * Math.PI;
				particleManager.restart();
			case ParticleProperties.Name.VERTICAL_ANGLE:
				editParticle.spray.verticalAngle = value / 180 * Math.PI;
				particleManager.restart();
			case ParticleProperties.Name.VERTICAL_RANDOM:
				editParticle.spray.verticalRandom = value / 180 * Math.PI;
				particleManager.restart();
			case ParticleProperties.Name.FORCE:
				editParticle.spray.force = value;
				particleManager.restart();
			case ParticleProperties.Name.RATE:
				editParticle.spray.rate = value;
				particleManager.restart();
		}
	}

	@:bind(btn_saveToServer, MouseEvent.CLICK)
	private function onBtnSaveToServer(e) {
		ServerManager.getInstance().list(onGetServerList, () -> {});
	}

	private function onGetServerList(data:Dynamic) {
		final saveDialog = new SaveDialog(this);
		saveDialog.showDialogWithData(data);
	}

	@:bind(btn_clearAll, MouseEvent.CLICK)
	private function onBtnClearAll(e) {
		particleManager.clear();
		meshManager.clear();
	}

	@:bind(btn_clearParticles, MouseEvent.CLICK)
	private function onBtnClearParticles(e) {
		particleManager.clear();
	}

	@:bind(btn_load, MouseEvent.CLICK)
	private function onBtnLoadClick(e) {
		var input = Syntax.code("document.createElement")('input');
		input.type = 'file';

		input.onchange = function(e) {
			var file:Dynamic = e.target.files[0];
			if (file) {
				var reader = new FileReader();

				reader.onload = function(e) {
					var content = e.target.result;
					final importObj = Json.parse(content);
					importSystemFromObj(importObj);
				};

				reader.readAsText(file);
			}
		};

		input.click();
	}

	public function importSystemFromObj(data:Dynamic) {
		particleManager.clear();
		meshManager.clear();
		materialManager.clear();

		// 測試前端的api
		// Manager.getInstance().importSystem(data);
		// Manager.getInstance().playEffect("4122731010-810112-4279-9996-81213010117686415", 0, 0, 1);
		// return;

		final _particle:Array<Dynamic> = data.frontend.particle;
		final _mesh:Array<Dynamic> = data.frontend.mesh;
		final _material:Array<Dynamic> = data.frontend.material;
		final _force = data.frontend.force;
		final _enviroment = data.frontend.enviroment;

		for (materialModel in _material) {
			final uuid = materialModel.uuid;
			final shaderModel = materialModel.extra.shader;
			switch (shaderModel.category) {
				case ShaderCategory.BASIC_SHADER:
					final mat = materialManager.addBasicMaterial(uuid, shaderModel.uuid, shaderModel.blending, shaderModel.transparent,
						shaderModel.depthWrite, shaderModel.side);
				case ShaderCategory.SPRITE_SHADER:
					final mat = materialManager.addBillBoardMaterial(uuid, shaderModel.uuid, shaderModel.blending, shaderModel.transparent,
						shaderModel.depthWrite, shaderModel.side);
				case ShaderCategory.PHONG_SHADER:
					final mat = materialManager.addMeshPhongMaterial(uuid, shaderModel.uuid);
					mat.color = shaderModel.color;
					mat.specular = shaderModel.specular;
					mat.emissive = shaderModel.emissive;
				case ShaderCategory.PARTICLE_SPRITE_SHADER:
					final mat = materialManager.addParticleSpriteShader(uuid, shaderModel.uuid, shaderModel.blending, shaderModel.transparent,
						shaderModel.depthWrite, shaderModel.side);
					mat.uniforms.baseColor.value.x = shaderModel.baseColor[0];
					mat.uniforms.baseColor.value.y = shaderModel.baseColor[1];
					mat.uniforms.baseColor.value.z = shaderModel.baseColor[2];
					mat.uniforms.usingNoise.value = shaderModel.usingNoise;
					mat.uniforms.usingMask.value = shaderModel.usingMask;
					mat.uniforms.usingTex.value = shaderModel.usingTex;
			}
		}

		for (meshModel in _mesh) {
			final uuid = meshModel.uuid;
			final name = meshModel.name;
			if (meshModel.extra == null) {
				continue;
			}
			final geometryModel = meshModel.extra.geometry;
			final materialModel = meshModel.extra.material;
			final material = materialManager.getSyncDataView().getItemByUuid(materialModel.uuid);
			switch (geometryModel.category) {
				case GeometryCategory.PLANE:
					meshManager.addPlane(uuid, geometryModel.uuid, name, material, geometryModel.geo.width, geometryModel.geo.height);
				case GeometryCategory.CUBE:
					meshManager.addBox(uuid, geometryModel.uuid, name, material, geometryModel.geo.width, geometryModel.geo.height, geometryModel.geo.depth);
				case GeometryCategory.SPHERE:
					meshManager.addSphere(uuid, geometryModel.uuid, name, material, geometryModel.geo.radius);
			}
		}

		function syncParticleFromModel(p:IParticle, model:Dynamic) {
			p.acceleration.x = model.acceleration[0];
			p.acceleration.y = model.acceleration[1];
			p.acceleration.z = model.acceleration[2];
			p.velocity.x = model.velocity[0];
			p.velocity.y = model.velocity[1];
			p.velocity.z = model.velocity[2];
			p.age = model.age;
			p.deadAge = model.deadAge;
			p.randomDeadAge = model.randomDeadAge;
			p.rotate = model.rotate;
			p.randomRotate = model.randomRotate;
			p.enabledRotateAlongSpeed = model.enabledRotateAlongSpeed;
			p.mass = model.mass;
			p.size = model.size;
			p.sizeIn = model.sizeIn;
			p.sizeOut = model.sizeOut;
			p.spray.force = model.spray.force;
			p.spray.horizonAngle = model.spray.horizonAngle;
			p.spray.horizonRandom = model.spray.horizonRandom;
			p.spray.verticalAngle = model.spray.verticalAngle;
			p.spray.verticalRandom = model.spray.verticalRandom;
			p.spray.rate = model.spray.rate;
			p.setPosition(model.position[0], model.position[1], model.position[2]);
		}

		for (particleModel in _particle) {
			final newEmitter = setParticle(particleModel.uuid, particleModel);
			syncParticleFromModel(newEmitter, particleModel);
			ParticleProperties.getInstance(newEmitter, prosList);
			if (particleModel.child != "") {
				final newParticle = setParticle(particleModel.child.uuid, particleModel.child);
				particleManager.setParticle(newEmitter, newParticle);
				ParticleProperties.getInstance(newParticle, prosList);
				syncParticleFromModel(newParticle, particleModel.child);
				if (particleModel.child.child != "") {
					final newParticle2 = setParticle(particleModel.child.child.uuid, particleModel.child.child);
					particleManager.setParticle(newParticle, newParticle2);
					syncParticleFromModel(newParticle2, particleModel.child.child);
					ParticleProperties.getInstance(newParticle2, prosList);
				}
			}
			particleManager.addEmitter(newEmitter);
		}

		if (data.editor.particle == null)
			return;

		final minMaxObjs:Array<Dynamic> = data.editor.particle;
		for (minMaxObj in minMaxObjs) {
			final p = particleManager.getParticleFromUuid(minMaxObj.uuid);
			if (p == null)
				continue;

			final minMaxs = minMaxObj.minMax;
			final keys = prosList.keys();
			var id = 0;
			while (keys.hasNext()) {
				final key = keys.next();
				final view = prosList.get(key);
				final minMax = minMaxs[id++];
				view.minPos = minMax[0];
				view.maxPos = minMax[1];
			}
			ParticleProperties.setInstance(p, prosList);
		}

		final enviromentModel = data.editor.enviroment;
		drp_loadModel.value = enviromentModel.model;
		onDrpLoadModelChange(null);

		pro_reflect.value = enviromentModel.reflect;
		onProReflectChange(null);

		pro_ambient.value = enviromentModel.ambient;
		onProAmbientChange(null);

		pro_envId.value = enviromentModel.envId;
		onProEnvIdChange(null);

		pro_shadow.value = enviromentModel.shadow;
		onProShadowChange(null);
	}

	private function setParticle(uuid:String, data:Dynamic):IParticle {
		final isEmitter = data.child != "";
		final mesh = meshManager.getSyncDataView().getItemByUuid(data.proxy);
		final particle:IParticle = isEmitter ? particleManager.createEmitter(data.uuid, mesh, false) : particleManager.createParticle(data.uuid, mesh, false);
		particle.name = data.name;
		return particle;
	}

	private function saveFile(jsonObj:Dynamic) {
		final blob = new Blob([Json.stringify(jsonObj, null, "  ")]);
		final link = Syntax.code("document.createElement")('a');
		link.href = Syntax.code("URL.createObjectURL")(blob);
		link.download = 'output.json';

		Syntax.code("document.body.appendChild")(link);
		link.click();
		Syntax.code("document.body.removeChild")(link);
	}

	@:bind(btn_export, MouseEvent.CLICK)
	private function onBtnExportClick(e) {
		final data = {
			frontend: createFrontendJsonObj()
		};
		saveFile(data);
	}

	@:bind(btn_save, MouseEvent.CLICK)
	private function onBtnSaveClick(e) {
		saveFile(getEditorSaveJsonObj());
	}

	public function getEditorSaveJsonObj() {
		final data = {
			frontend: createFrontendJsonObj(),
			editor: createEditorJsonObj()
		};
		return data;
	}

	private function createEditorJsonObj() {
		final editor = {
			particle: ParticleProperties.convertToJsonObject(this),
			enviroment: {
				model: drp_loadModel.value,
				reflect: pro_reflect.value,
				ambient: pro_ambient.value,
				envId: pro_envId.value,
				shadow: pro_shadow.value
			}
		}
		return editor;
	}

	private function createFrontendJsonObj() {
		final frontend = {
			particle: particleManager.convertToJsonObject(),
			mesh: meshManager.convertToJsonObject(),
			material: materialManager.convertToJsonObject(),
			force: {},
			enviroment: {}
		};
		return frontend;
	}

	@:bind(pg_particleSetting, UIEvent.CHANGE)
	private function onProParticleSettingChange(e) {
		if (editParticle == null)
			return;

		editParticle.name = pro_pName.value;
		editParticle.proxy = pro_pGeometry.value.item;

		// editParticle.clearPool();

		// particleManager.syncTreeNode();
		// particleManager.clearPool();

		// editParticle.deadAge = pro_pDeadAge.value;
		// editParticle.randomDeadAge = pro_pRandomDeadAge.value;
		// editParticle.velocity.x = pro_pVelocity_x.value;
		// editParticle.velocity.y = pro_pVelocity_y.value;
		// editParticle.velocity.z = pro_pVelocity_z.value;
		// editParticle.rotate = pro_pRotate.value;
		// editParticle.rotateSpeed = pro_pRotateSpeed.value;

		// editParticle.proxy.material = mList[0];
		// editParticle.proxy.material = materialManager.getMaterialById(0);
		// trace("change mateeral");

		// if (editNode == null)
		// 	return;
		// editNode.text = pro_pName.value;
	}

	@:bind(btn_addPhoneMaterial, MouseEvent.CLICK)
	private function onBtnAddPhoneClick(e) {
		materialManager.addMeshPhongMaterial();
	}

	@:bind(btn_addColorMaterial, MouseEvent.CLICK)
	private function onBtnAddColorClick(e) {
		materialManager.addBasicMaterial();
	}

	@:bind(btn_addSpriteMaterial, MouseEvent.CLICK)
	private function onBtnAddSpriteClick(e) {
		materialManager.addBillBoardMaterial();
	}

	@:bind(btn_addParticleSpriteMaterial, MouseEvent.CLICK)
	private function onBtnAddParticleSpriteClick(e) {
		materialManager.addParticleSpriteShader();
	}

	// @:bind(btn_addMaterial, MouseEvent.CLICK)
	// private function onBtnAddMaterialClick(e) {
	// 	switch (dd_createMaterialList.selectedIndex) {
	// 		case 0:
	// 			materialManager.addMeshPhongMaterial();
	// 		case 1:
	// 			materialManager.addBasicMaterial();
	// 		case 2:
	// 			materialManager.addBillBoardMaterial();
	// 		case 3:
	// 			materialManager.addParticleSpriteShader();
	// 	};
	// }

	@:bind(btn_refresh, MouseEvent.CLICK)
	private function onBtnRefreshClick(e) {
		particleManager.restart();
	}

	@:bind(btn_addPlane, MouseEvent.CLICK)
	private function onBtnAddPlaneClick(e) {
		meshManager.addPlane("", "", "dd", materialManager.getSyncDataView().getItemById(0), pro_planeConsWidth.value, pro_planeConsHeight.value);
	}

	@:bind(btn_addSphere, MouseEvent.CLICK)
	private function onBtnAddSphereClick(e) {
		meshManager.addSphere("", "", "ss", materialManager.getSyncDataView().getItemById(0), pro_sphereConsRadius.value);
	}

	@:bind(btn_addBox, MouseEvent.CLICK)
	private function onBtnAddBoxClick(e) {
		meshManager.addBox("", "", "bb", materialManager.getSyncDataView().getItemById(0), pro_boxConsWidth.value, pro_boxConsDepth.value,
			pro_boxConsHeight.value);
	}

	@:bind(cp_phong_baseColor, UIEvent.CHANGE)
	private function onCpPhongColorChange(e) {
		trace("切換材質顔色");
		if (editMaterial == null)
			return;
		final rgb = getRBG(cp_phong_baseColor.value);
		editMaterial.color.r = rgb[0] / 255;
		editMaterial.color.g = rgb[1] / 255;
		editMaterial.color.b = rgb[2] / 255;
	}

	@:bind(cp_phong_specularColor, UIEvent.CHANGE)
	private function onCpPhongSpecularColorChange(e) {
		trace("切換材質顔色");
		if (editMaterial == null)
			return;
		final rgb = getRBG(cp_phong_specularColor.value);
		editMaterial.specular.r = rgb[0] / 255;
		editMaterial.specular.g = rgb[1] / 255;
		editMaterial.specular.b = rgb[2] / 255;
	}

	@:bind(cp_phong_emissiveColor, UIEvent.CHANGE)
	private function onCpPhongEmissiveColorChange(e) {
		trace("切換材質顔色");
		if (editMaterial == null)
			return;
		final rgb = getRBG(cp_phong_emissiveColor.value);
		editMaterial.emissive.r = rgb[0] / 255;
		editMaterial.emissive.g = rgb[1] / 255;
		editMaterial.emissive.b = rgb[2] / 255;
	}

	@:bind(cp_basic_baseColor, UIEvent.CHANGE)
	private function onCpBasicColorChange(e) {
		trace("切換材質顔色");
		if (editMaterial == null)
			return;
		final rgb = getRBG(cp_basic_baseColor.value);
		editMaterial.uniforms.baseColor.value.x = rgb[0] / 255;
		editMaterial.uniforms.baseColor.value.y = rgb[1] / 255;
		editMaterial.uniforms.baseColor.value.z = rgb[2] / 255;
	}

	@:bind(cp_particle_baseColor, UIEvent.CHANGE)
	private function onCpParticleColorChange(e) {
		trace("切換材質顔色");
		if (editMaterial == null)
			return;
		final rgb = getRBG(cp_particle_baseColor.value);
		editMaterial.uniforms.baseColor.value.x = rgb[0] / 255;
		editMaterial.uniforms.baseColor.value.y = rgb[1] / 255;
		editMaterial.uniforms.baseColor.value.z = rgb[2] / 255;
	}

	private function hideAllMaterialSetting() {
		for (index => value in [vbox_basicShader, vbox_particleShader, vbox_phongShader]) {
			value.hide();
		}
	}

	private function onTvMaterialListClick(e:EventWithParams) {
		if (e.data == null)
			return;

		trace("點擊材質:" + e.data.category);

		pg_shaderSetting.disabled = false;

		hideAllMaterialSetting();

		final material = e.data.item;
		editMaterial = material;

		pro_shaderBlending.value = pro_shaderBlending.dataSource.get(editMaterial.blending).text;
		pro_shaderSide.value = pro_shaderSide.dataSource.get(editMaterial.side).text;
		pro_shaderDepthWrite.value = editMaterial.depthWrite;
		pro_shaderTransparent.value = editMaterial.transparent;
		pro_shaderOpacity.value = editMaterial.opacity;

		switch (e.data.category) {
			case ShaderCategory.BASIC_SHADER:
				vbox_basicShader.show();

				cp_basic_baseColor.value = getColorFromRGB(material.uniforms.baseColor.value.x, material.uniforms.baseColor.value.y,
					material.uniforms.baseColor.value.z);

			case ShaderCategory.SPRITE_SHADER:
			case ShaderCategory.PHONG_SHADER:
				vbox_phongShader.show();

				cp_phong_baseColor.value = getColorFromRGB(material.color.r, material.color.g, material.color.b);
				cp_phong_specularColor.value = getColorFromRGB(material.specular.r, material.specular.g, material.specular.b);
				cp_phong_emissiveColor.value = getColorFromRGB(material.emissive.r, material.emissive.g, material.emissive.b);

			case ShaderCategory.PARTICLE_SPRITE_SHADER:
				vbox_particleShader.show();

				cp_particle_baseColor.value = getColorFromRGB(material.uniforms.baseColor.value.x, material.uniforms.baseColor.value.y,
					material.uniforms.baseColor.value.z);

				pro_particleShaderUsingNoise.value = (material.uniforms.usingNoise.value == 1);
				pro_particleShaderUsingMask.value = (material.uniforms.usingMask.value == 1);
				pro_particleShaderUsingTex.value = (material.uniforms.usingTex.value == 1);
		}
	}

	@:bind(pro_shaderBlending, UIEvent.CHANGE)
	private function onProShaderBlendingChange(e) {
		if (editMaterial == null)
			return;

		// 注意！材質的參數blending需要integer!
		editMaterial.blending = Std.parseInt(pro_shaderBlending.value.id);
		editMaterial.needUpdate = true;
	}

	@:bind(pro_shaderSide, UIEvent.CHANGE)
	private function onProShaderSideChange(e) {
		if (editMaterial == null)
			return;
		// 注意！材質的參數side需要integer!
		editMaterial.side = Std.parseInt(pro_shaderSide.value.id);
	}

	@:bind(pro_shaderTransparent, UIEvent.CHANGE)
	private function onProShaderTransparentChange(e) {
		if (editMaterial == null)
			return;
		editMaterial.transparent = pro_shaderTransparent.value;
	}

	@:bind(pro_shaderDepthWrite, UIEvent.CHANGE)
	private function onProShaderDepthWriteChange(e) {
		if (editMaterial == null)
			return;
		editMaterial.depthWrite = pro_shaderDepthWrite.value;
	}

	@:bind(pro_shaderOpacity, UIEvent.CHANGE)
	private function onProShaderOpacityChange(e) {
		if (editMaterial == null)
			return;
		editMaterial.opacity = pro_shaderOpacity.value;
	}

	@:bind(pro_particleShaderUsingNoise, UIEvent.CHANGE)
	private function onProParticleShaderUsingNoiseClick(e) {
		if (editMaterial == null)
			return;
		editMaterial.uniforms.usingNoise.value = pro_particleShaderUsingNoise.value;
	}

	@:bind(pro_particleShaderUsingMask, UIEvent.CHANGE)
	private function onProParticleShaderUsingMaskClick(e) {
		if (editMaterial == null)
			return;
		editMaterial.uniforms.usingMask.value = pro_particleShaderUsingMask.value;
	}

	@:bind(pro_particleShaderUsingTex, UIEvent.CHANGE)
	private function onProParticleShaderUsingTexClick(e) {
		if (editMaterial == null)
			return;
		editMaterial.uniforms.usingTex.value = pro_particleShaderUsingTex.value;
	}

	@:bind(btn_createOneLevelParticle, MouseEvent.CLICK)
	private function onBtnCreateOneLevelParticleClick(e) {
		createOneLevelParticle();
	}

	@:bind(btn_createTwoLevelParticle, MouseEvent.CLICK)
	private function onBtnCreateTwoLevelParticleClick(e) {
		createTwoLevelParticle();
	}

	@:bind(btn_removeParticle, MouseEvent.CLICK)
	private function onBtnRemoveParticleClick(e) {
		if (editParticle == null)
			return;

		Dialogs.messageBox('請問確定刪除嗎？', '請問確定刪除嗎？', 'question', true, (btn:DialogButton) -> {
			switch (btn) {
				case DialogButton.YES:
					var current = editParticle;
					while (current != null) {
						particleManager.removeParticle(current);
						ParticleProperties.removeInstance(current);
						current = current.parent;
					}

					editParticle = null;
					box_pProperties.disabled = true;
					pg_particleSetting.disabled = true;

					NotificationManager.instance.addNotification({
						title: "刪除完成",
						body: "刪除完成"
					});
			}
		});
	}

	@:bind(btn_removeMaterial, MouseEvent.CLICK)
	private function onBtnRemoveMaterialClick(e) {
		if (editMaterial == null)
			return;

		Dialogs.messageBox('請問確定刪除嗎？', '請問確定刪除嗎？', 'question', true, (btn:DialogButton) -> {
			switch (btn) {
				case DialogButton.YES:
					materialManager.getSyncDataView().removeNodeByItem(editMaterial);
					editMaterial = null;

					NotificationManager.instance.addNotification({
						title: "刪除完成",
						body: "刪除完成"
					});
			}
		});
	}

	@:bind(btn_removeGeometry, MouseEvent.CLICK)
	private function onBtnRemoveGeometryClick(e) {
		if (editGeometry == null)
			return;
		meshManager.getSyncDataView().removeNodeByItem(editGeometry);
		editGeometry = null;
	}

	// @:bind(pro_particleShaderUsingTex, UIEvent.CHANGE)
	// private function onProParticleShaderUsingTexClick(e) {
	// 	if (editMaterial == null)
	// 		return;
	// 	editMaterial.uniforms.usingTex.value = pro_particleShaderUsingTex.value;
	// }
	// @:bind(tv_geometryList, UIEvent.CHANGE)
	// private function onTvGeometryListClick(e:UIEvent) {
	// 	final mesh = tv_geometryList.selectedItem.mesh;
	// 	final id = materialManager.getIdByMaterial(mesh.material);
	// 	materialManager.setDdMaterialTo(id);
	// }

	private function onTvMeshChange(e:EventWithParams) {
		final mesh = e.data.item;
		if (mesh == null) {
			pg_geometrySetting.disabled = true;
			return;
		}
		pg_geometrySetting.disabled = false;

		editGeometry = mesh;

		final id = materialManager.getSyncDataView().getIdByItem(mesh.material);
		// 這邊會觸發onProGMaterialChange的方法，所以editGeometry = mesh一定要放在前面
		materialManager.setDdMaterialTo(id);

		pro_gName.value = e.data.name;
	}

	private function onProGMaterialChange(e:EventWithParams) {
		if (e.data == null)
			return;
		trace("點擊材質切換按鈕:" + e.data.text);

		if (editGeometry == null)
			return;

		final material = e.data.item;
		editGeometry.material = material;
	}

	// @:bind(pro_geometryList, UIEvent.CHANGE)
	// private function onProGeometryListChange(e) {
	// 	if (editParticle == null)
	// 		return;
	// 	// 在syntax.code中使用變量的方式
	// 	// final geo = Syntax.code("new THREE[{0}]", pro_geometryList.value.buffer)(1, 1);
	// 	final geo = switch (pro_geometryList.value.buffer) {
	// 		case "PlaneBufferGeometry":
	// 			Syntax.code("new THREE.PlaneBufferGeometry")(1, 1);
	// 		case "SphereGeometry":
	// 			Syntax.code("new THREE.SphereGeometry")(1);
	// 		case "BoxGeometry":
	// 			Syntax.code("new THREE.BoxGeometry")(1, 1, 1);
	// 		case _:
	// 			Syntax.code("new THREE.PlaneBufferGeometry")(1, 1);
	// 	}
	// 	final mesh = Syntax.code("new THREE.Mesh")(geo);
	// 	if (editParticle.proxy != null) {
	// 		mesh.material = editParticle.proxy.material;
	// 		editParticle.proxy = mesh;
	// 	}
	// }

	private function onPMParentChange(e:EventWithParams) {
		if (editParticle == null)
			return;
		final particle:Emitter = e.data.item;
		if (particle == null)
			return;
		particleManager.setParticle(particle, editParticle);
	}

	private function getPropertiesMinMax() {
		final minMaxs:Array<Array<Float>> = ParticleProperties.getInstance(editParticle, prosList);
		final keys = prosList.keys();
		var id = 0;
		while (keys.hasNext()) {
			final key = keys.next();
			final view = prosList.get(key);
			final minMax = minMaxs[id++];
			view.minPos = minMax[0];
			view.maxPos = minMax[1];
		}
	}

	private function onPMSelectNode(e:EventWithParams) {
		editNode = e.data.node;
		editParticle = e.data.particle;

		if (editParticle == null) {
			box_pProperties.disabled = true;
			pg_particleSetting.disabled = true;
			return;
		}

		box_pProperties.disabled = false;
		pg_particleSetting.disabled = false;

		pro_pName.value = editParticle.name;

		getPropertiesMinMax();

		prosList.get(ParticleProperties.Name.DEAD).currentValue = editParticle.deadAge;
		prosList.get(ParticleProperties.Name.DEAD_RANDOM).currentValue = editParticle.randomDeadAge;
		prosList.get(ParticleProperties.Name.ACCELERATION_X).currentValue = editParticle.acceleration.x;
		prosList.get(ParticleProperties.Name.ACCELERATION_Y).currentValue = editParticle.acceleration.y;
		prosList.get(ParticleProperties.Name.ACCELERATION_Z).currentValue = editParticle.acceleration.z;
		prosList.get(ParticleProperties.Name.VELOCITY_X).currentValue = editParticle.velocity.x;
		prosList.get(ParticleProperties.Name.VELOCITY_Y).currentValue = editParticle.velocity.y;
		prosList.get(ParticleProperties.Name.VELOCITY_Z).currentValue = editParticle.velocity.z;
		prosList.get(ParticleProperties.Name.ANGLE).currentValue = editParticle.rotate / Math.PI * 180;
		prosList.get(ParticleProperties.Name.ANGLE_RANDOM).currentValue = editParticle.randomRotate / Math.PI * 180;
		prosList.get(ParticleProperties.Name.ROTATION_SPEED).currentValue = editParticle.rotateSpeed;
		prosList.get(ParticleProperties.Name.POSITION_RANDOM_X).currentValue = editParticle.randomPosition.x;
		prosList.get(ParticleProperties.Name.POSITION_RANDOM_Y).currentValue = editParticle.randomPosition.y;
		prosList.get(ParticleProperties.Name.POSITION_RANDOM_Z).currentValue = editParticle.randomPosition.z;
		prosList.get(ParticleProperties.Name.SCALE).currentValue = editParticle.size;
		prosList.get(ParticleProperties.Name.SCALE_RANDOM).currentValue = editParticle.randomSize;
		prosList.get(ParticleProperties.Name.GROWTH_TIME).currentValue = editParticle.sizeIn;
		prosList.get(ParticleProperties.Name.SHRINK_TIME).currentValue = editParticle.sizeOut;

		var isEmitter = true;
		try {
			cast(editParticle, Emitter);
		} catch (e) {
			isEmitter = false;
		}

		if (isEmitter) {
			prosList.get(ParticleProperties.Name.HORIZON_ANGLE).currentValue = editParticle.spray.horizonAngle / Math.PI * 180;
			prosList.get(ParticleProperties.Name.HORIZON_RANDOM).currentValue = editParticle.spray.horizonRandom / Math.PI * 180;
			prosList.get(ParticleProperties.Name.VERTICAL_ANGLE).currentValue = editParticle.spray.verticalAngle / Math.PI * 180;
			prosList.get(ParticleProperties.Name.VERTICAL_RANDOM).currentValue = editParticle.spray.verticalRandom / Math.PI * 180;
			prosList.get(ParticleProperties.Name.FORCE).currentValue = editParticle.spray.force;
			prosList.get(ParticleProperties.Name.RATE).currentValue = editParticle.spray.rate;
			prosList.get(ParticleProperties.Name.POSITION_X).currentValue = editParticle.getPosition().x;
			prosList.get(ParticleProperties.Name.POSITION_Y).currentValue = editParticle.getPosition().y;
			prosList.get(ParticleProperties.Name.POSITION_Z).currentValue = editParticle.getPosition().z;
		}

		prosList.get(ParticleProperties.Name.HORIZON_ANGLE).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.HORIZON_RANDOM).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.VERTICAL_ANGLE).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.VERTICAL_RANDOM).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.FORCE).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.RATE).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.POSITION_X).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.POSITION_Y).disabled = !isEmitter;
		prosList.get(ParticleProperties.Name.POSITION_Z).disabled = !isEmitter;

		final id = meshManager.getSyncDataView().getIdByItem(editParticle.proxy);

		if (id >= 0) {
			meshManager.setProMeshById(id);
		}
	}

	private function makeParticleToEmitter() {
		// particleManager.createEmitter
	}

	private function onTick() {
		time += timeForTick;
		particleManager.getParticleSystem().update(timeForTick * .001);

		if (particleManager.getParticleSystem().getParticleCount() == 0) {
			particleManager.restart();
		}

		viewer.impl.sceneUpdated(true);
	}

	private function showHideScene(show:Bool) {
		final currentModel = viewer.impl.model;
		final fragIds:Array<Int> = currentModel.getData().fragments.fragId2dbId;
		for (i in 0...fragIds.length) {
			final fragProxy = viewer.impl.getFragmentProxy(currentModel, i);

			// fragProxy.getAnimTransform();
			// // fragProxy.position = Syntax.code("new THREE.Vector3")(0, 0, 5);
			// // fragProxy.scale = Syntax.code("new THREE.Vector3")(0, 0, 1);
			// fragProxy.updateAnimTransform();

			if (show) {
				fragProxy.setMaterial(oldMaterial[i]);
			} else {
				fragProxy.setMaterial(invisibleMaterial);
			}
		}
	}

	private function saveOldMaterial() {
		while (oldMaterial.length > 0) {
			oldMaterial.pop();
		}

		final currentModel = viewer.impl.model;
		final fragIds:Array<Int> = currentModel.getData().fragments.fragId2dbId;
		for (i in 0...fragIds.length) {
			final fragProxy = viewer.impl.getFragmentProxy(currentModel, i);
			oldMaterial.push(fragProxy.getMaterial());
		}
	}

	override function onReady() {
		super.onReady();

		hideAllMaterialSetting();

		final options = {
			env: 'Local',
			offline: 'true',
			useADP: false
		};
		Syntax.code("Autodesk.Viewing.Initializer")(options, () -> {
			viewer.start();

			viewer.impl.matman().addMaterial("invisibleMaterial", invisibleMaterial, true);

			viewer.setLightPreset(0);
			viewer.setGroundReflection(false);
			viewer.setOptimizeNavigation(true);
			viewer.setProgressiveRendering(true);

			viewer.setGhosting(false);
			viewer.setQualityLevel(false, false);
			viewer.setGroundShadow(false);
			viewer.hideLines(true);
			viewer.hidePoints(true);

			// viewer.disableHighlight(true);
			// viewer.disableSelection(true);

			cp_backColorTop.value = 13158600;
			cp_backColorBottom.value = 0;
			onCpBackColorTopChange(null);

			drp_loadModel.value = drp_loadModel.dataSource.get(0);
			onDrpLoadModelChange(null);

			particleManager.getParticleSystem().setViewer(viewer);

			initMaterial();
			initMesh();
			initParticleSystem();

			// // final keys:Array<String> = Reflect.fields(viewer.impl.matman()._materials);
			// // for (index => value in keys) {
			// // 	// trace(index);
			// // 	trace(value);
			// // 	final mat = Reflect.field(viewer.impl.matman()._materials, value);
			// // 	// trace(mat);
			// // 	if(mat == materialManager.getMaterialById(2)){
			// // 		trace('delete material');
			// // 		viewer.impl.matman().removeMaterial(value);
			// // 	}
			// // }

			// viewer.impl.matman().removeMaterial("p_0");
			// viewer.impl.matman().addMaterial("p_0", materialManager.getMaterialById(2));

			// Main.log(viewer.impl.matman()._materials);
			// // for (index => value in viewer.impl.matman()._materials) {
			// // 	trace(index);
			// // }
		});

		// function translateByID(fragId, x, y, z, model) {
		// 	const fragProxy = viewer.impl.getFragmentProxy(model, fragId);

		// 	fragProxy.getAnimTransform();

		// 	fragProxy.position = new THREE.Vector3(x, y, z);

		// 	fragProxy.updateAnimTransform();

		// 	// const material = createShaderMaterial();
		// 	// fragProxy.setMaterial(material);
		//   }

		viewer.addEventListener(Syntax.code("Autodesk.Viewing.GEOMETRY_LOADED_EVENT"), (e) -> {
			isViewerReady = true;
			saveOldMaterial();
			onProSceneChange(null);

			// final fragProxy = viewer.impl.getFragmentProxy(currentModel, fragIds[0]);
			// final selectionBox = Syntax.code("new THREE.BoxHelper")();
			// // viewer.impl.matman().addMaterial("dd", selectionBox.material, true);
			// selectionBox.material.depthTest = false;
			// selectionBox.material.transparent = false;
			// selectionBox.visible = true;

			// var geometry = Syntax.code("new THREE.Geometry")().fromBufferGeometry(selectionBox.geometry);
			// // var material = selectionBox.material;
			// var material = Syntax.code("new THREE.MeshBasicMaterial")({ color: 0x00ff00 }); // 设置BoxHelper的材料和颜色
			// var mesh = Syntax.code("new THREE.Mesh")(geometry, material);

			// viewer.impl.scene.add(mesh);
		});
	}

	private function createOneLevelParticle() {
		final p = particleManager.createParticle("", meshManager.getSyncDataView().getItemById(1), true);
		p.deadAge = 5;

		final e = particleManager.createEmitter("", meshManager.getSyncDataView().getItemById(0), true);
		e.spray.force = 0.2;
		e.deadAge = 10.0;

		particleManager.setParticle(e, p);
		particleManager.addEmitter(e);

		ParticleProperties.getInstance(p, prosList);
		ParticleProperties.getInstance(e, prosList);
	}

	private function createTwoLevelParticle() {
		final p = particleManager.createParticle("", meshManager.getSyncDataView().getItemById(1), true);
		p.deadAge = 3;

		final e = particleManager.createEmitter("", meshManager.getSyncDataView().getItemById(0), true);
		e.spray.force = 0.2;
		e.deadAge = 5.0;

		final e2 = particleManager.createEmitter("", meshManager.getSyncDataView().getItemById(0), true);
		e2.spray.force = 0.2;
		e2.deadAge = 10.0;

		particleManager.setParticle(e2, e);
		particleManager.setParticle(e, p);
		particleManager.addEmitter(e2);

		ParticleProperties.getInstance(p, prosList);
		ParticleProperties.getInstance(e, prosList);
		ParticleProperties.getInstance(e2, prosList);
	}

	private function initParticleSystem() {
		createOneLevelParticle();

		// var loader = Syntax.code("new THREE.TextureLoader")();
		// loader.load('../../assets/t1.png', function(t) {
		// 	t.minFilter = Syntax.code("THREE.LinearMipMapLinearFilter");
		// 	t.magFilter = Syntax.code("THREE.LinearFilter");
		// 	tList.push(t);

		// 	materialManager.getSyncDataView().getItemById(3).uniforms.usingTex.value = 1;
		// 	materialManager.getSyncDataView().getItemById(3).uniforms.colorTex.value = t;

		// 	// trace(materialManager.getMaterialById(3).uniforms.colorTex);

		// 	// p.proxy.material.uniforms.usingTex.value = 1;
		// 	// p.proxy.material.uniforms.colorTex.value = t;
		// });
	}

	private function initMesh() {
		meshManager.addPlane("", "", "平面", materialManager.getSyncDataView().getItemById(0), 1, 1);
		meshManager.addSphere("", "", "球體", materialManager.getSyncDataView().getItemById(1), .1);
	}

	private function initMaterial() {
		// materialManager.addBasicMaterial();
		// materialManager.addBillBoardMaterial();

		materialManager.addParticleSpriteShader();
		materialManager.addMeshPhongMaterial();

		materialManager.getSyncDataView().getItemById(0).uniforms.usingNoise.value = 1;
		// materialManager.getMaterialById(2).specular.r = 0;
		// materialManager.getMaterialById(2).specular.g = 0;
		// materialManager.getMaterialById(2).specular.b = 0;
		// materialManager.getMaterialById(2).shininess = 0;
		// materialManager.getSyncDataView().getItemById(2).emissive.r = .1;
		// materialManager.getSyncDataView().getItemById(2).emissive.g = 0;
		// materialManager.getSyncDataView().getItemById(2).emissive.b = 0;
		// materialManager.getSyncDataView().getItemById(0).side = 2;
	}

	@:bind(drp_loadModel, UIEvent.CHANGE)
	private function onDrpLoadModelChange(e) {
		if (lastLoadingModel == drp_loadModel.value.text)
			return;
		viewer.tearDown();
		viewer.loadModel(drp_loadModel.value.path, null, () -> {
			viewer.setProgressiveRendering(true);

			lastLoadingModel = drp_loadModel.value.text;
		}, null);
	}

	@:bind(cp_backColorTop, UIEvent.CHANGE)
	private function onCpBackColorTopChange(e) {
		changeViewerBackgroundColor();
	}

	@:bind(cp_backColorBottom, UIEvent.CHANGE)
	private function onCpBackColorBottomChange(e) {
		changeViewerBackgroundColor();
	}

	@:bind(pro_scene, UIEvent.CHANGE)
	private function onProSceneChange(e) {
		if (!isViewerReady)
			return;
		showHideScene(pro_scene.value);
	}

	@:bind(pro_envId, UIEvent.CHANGE)
	private function onProEnvIdChange(e) {
		if (!isViewerReady)
			return;
		viewer.setLightPreset(pro_envId.value);
	}

	@:bind(pro_reflect, UIEvent.CHANGE)
	private function onProReflectChange(e) {
		if (!isViewerReady)
			return;
		viewer.setGroundReflection(pro_reflect.value);
	}

	@:bind(pro_ambient, UIEvent.CHANGE)
	private function onProAmbientChange(e) {
		if (!isViewerReady)
			return;
		viewer.setQualityLevel(pro_ambient.value, true);
	}

	@:bind(pro_shadow, UIEvent.CHANGE)
	private function onProShadowChange(e) {
		if (!isViewerReady)
			return;
		viewer.setGroundShadow(pro_shadow.value);
	}

	private function changeViewerBackgroundColor() {
		final topColor = getRBG(cp_backColorTop.value);
		final bottomColor = getRBG(cp_backColorBottom.value);
		viewer.setBackgroundColor(topColor[0], topColor[1], topColor[2], bottomColor[0], bottomColor[1], bottomColor[2]);
	}

	private function getRBG(color:Int):Array<Int> {
		final red = (color >> 16) & 255;
		final green = (color >> 8) & 255;
		final blue = color & 255;
		return [red, green, blue];
	}

	private function getColorFromRGB(red:Int, green:Int, blue:Int):Int {
		red *= 255;
		green *= 255;
		blue *= 255;

		// 确保颜色组件值在0到255的范围内
		red = red & 0xFF;
		green = green & 0xFF;
		blue = blue & 0xFF;

		// 按位或操作生成最终颜色值
		var color = (red << 16) | (green << 8) | blue;
		return color;
	}

	public static function generateUUID():String {
		var uuid:String = "";
		for (i in 0...32) {
			if (i == 8 || i == 12 || i == 16 || i == 20) {
				uuid += "-";
			}
			var randomByte:Int = Math.floor(Math.random() * 16);
			uuid += Std.string(i == 12 ? 4 : (i == 16 ? (randomByte & 3 | 8) : randomByte));
		}
		return uuid;
	}

	public function getMaterialManager() {
		return materialManager;
	}

	public function getMeshManager() {
		return meshManager;
	}
}
