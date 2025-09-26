import syncData.SyncDataView;

interface IEditorManager {
	function getSyncDataView():SyncDataView;
	function convertToJsonObject():Dynamic;
	function clear():Void;
}
