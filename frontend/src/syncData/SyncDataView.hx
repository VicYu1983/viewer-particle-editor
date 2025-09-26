package syncData;

import haxe.ui.core.IDataComponent;

final class SyncDataView {
	private final nodeList:Array<SyncNode> = [];
	private final viewLists:Array<IDataComponent> = [];
	private var id:Int = 0;

	public function new() {}

	public function addView(view:IDataComponent) {
		if (viewLists.contains(view)) {
			return;
		}
		viewLists.push(view);
	}

	public function addNode(name:String, item:Dynamic, uuid:String = "", ?extra:Dynamic) {
		var node = new SyncNode();
		node.id = id++;
		node.uuid = uuid == "" ? MainView.generateUUID() : uuid;
		node.name = name;
		node.item = item;
		node.extra = extra;
		nodeList.push(node);
		syncTableView();
	}

	public function getItemByUuid(uuid:String) {
		for (node in nodeList) {
			if (node.uuid == uuid)
				return node.item;
		}
		return null;
	}

	public function getItemById(id:Int):Dynamic {
		final node = getNodeById(id);
		if (node == null)
			return null;
		return node.item;
	}

	public function getIdByItem(item:Dynamic):Int {
		final node = getNodeByItem(item);
		if (node == null)
			return -1;
		return node.id;
	}

	public function getNodeByItem(item:Dynamic):SyncNode {
		for (node in nodeList) {
			if (node.item == item)
				return node;
		}
		return null;
	}

	public function getNodeById(id:Int):SyncNode {
		for (node in nodeList) {
			if (node.id == id)
				return node;
		}
		return null;
	}

	public function removeNodeByItem(item:Dynamic) {
		var node = getNodeByItem(item);
		if (node != null) {
			nodeList.remove(node);
			syncTableView();
		}
	}

	public function getNodeList() {
		return nodeList;
	}

	public function clear() {
		while (nodeList.length > 0) {
			nodeList.pop();
		}
		syncTableView();
	}

	private function syncTableView() {
		for (list in viewLists) {
			list.dataSource.clear();
			for (node in nodeList) {
				list.dataSource.add(node.getViewNode());
			}
		}
	}
}
