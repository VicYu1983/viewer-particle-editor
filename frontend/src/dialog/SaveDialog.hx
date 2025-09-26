package dialog;

import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.events.UIEvent;
import haxe.Json;
import haxe.ui.notifications.NotificationManager;
import haxe.ui.events.MouseEvent;
import syncData.SyncDataView;
import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/save_dialog_view.xml"))
class SaveDialog extends Dialog {
	private final syncView:SyncDataView = new SyncDataView();

	private final facade:MainView;

	private var selectItem:Dynamic;

	public function new(facade:MainView) {
		super();

		this.facade = facade;

		tv_particleEffectList.onChange = function(e:UIEvent) {
			selectItem = tv_particleEffectList.selectedItem;

			txt_effectName.text = selectItem.item.name;
			txt_effectDescribtion.text = selectItem.item.describtion;
		}

		syncView.addView(tv_particleEffectList);
	}

	public function showDialogWithData(data:Dynamic) {
		showDialog();
		syncList(data);
	}

	private function syncList(data:Dynamic) {
		syncView.clear();
		final effects:Array<Dynamic> = data;
		effects.reverse();
		for (effect in effects) {
			syncView.addNode(effect.name, effect);
		}
	}

	@:bind(btn_close, MouseEvent.CLICK)
	private function onBtnCloseClick(e) {
		hideDialog(DialogButton.CANCEL);
		selectItem = null;
	}

	@:bind(btn_save, MouseEvent.CLICK)
	private function onBtnSaveClick(e) {
		// if (selectItem == null)
		// 	return;

		if (txt_effectName.text == "" || txt_effectDescribtion.text == "") {
			NotificationManager.instance.addNotification({
				title: "名稱和描述不能為空",
				body: "名稱和描述不能為空"
			});
			return;
		}
		final obj = facade.getEditorSaveJsonObj();
		ServerManager.getInstance().save(txt_effectName.text, txt_effectDescribtion.text, Json.stringify(obj), (data:Dynamic) -> {
			syncList(data);
		});
	}

	@:bind(btn_delete, MouseEvent.CLICK)
	private function onBtnDeleteClick(e) {
		if (selectItem == null)
			return;
		Dialogs.messageBox('請問確定刪除嗎？', '請問確定刪除嗎？', 'question', true, (btn:DialogButton) -> {
			switch (btn) {
				case DialogButton.YES:
					ServerManager.getInstance().delete(selectItem.item.id, (data:Dynamic) -> {
						syncList(data);
						
						NotificationManager.instance.addNotification({
							title: "刪除完成",
							body: "刪除完成"
						});
					});
			}
		});
	}

	// @:bind(btn_saveAs, MouseEvent.CLICK)
	// private function onBtnSaveAsClick(e) {
	// 	if (txt_effectName.text == "" || txt_effectDescribtion.text == "") {
	// 		NotificationManager.instance.addNotification({
	// 			title: "名稱和描述不能為空",
	// 			body: "名稱和描述不能為空"
	// 		});
	// 		return;
	// 	}
	// 	final obj = facade.getEditorSaveJsonObj();
	// 	ServerManager.getInstance().save(txt_effectName.text, txt_effectDescribtion.text, Json.stringify(obj), (data:Dynamic) -> {
	// 		syncList(data);
	// 	});
	// }

	@:bind(btn_load, MouseEvent.CLICK)
	private function onBtnLoadClick(e) {
		if (selectItem == null)
			return;

		Dialogs.messageBox('請問確定打開嗎？', '請問確定打開嗎？', 'question', true, (btn:DialogButton) -> {
			switch (btn) {
				case DialogButton.YES:
					ServerManager.getInstance().load(selectItem.item.id, (data:Dynamic) -> {
						facade.importSystemFromObj(Json.parse(data.json));
						onBtnCloseClick(null);

						NotificationManager.instance.addNotification({
							title: "打開完成",
							body: "打開完成"
						});
					});
			}
		});
	}
}
