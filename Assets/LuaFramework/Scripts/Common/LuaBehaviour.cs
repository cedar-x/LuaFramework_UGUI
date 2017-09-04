using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    public class LuaBehaviour : View {
        private string data = null;
        private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();

        protected void Awake() {
            Util.CallMethod(name.Substring(name.IndexOf('.')+1), "Awake", gameObject);
        }

        protected void Start() {
            Util.CallMethod(name.Substring(name.IndexOf('.') + 1), "Start");
        }

        protected void OnClick() {
            Util.CallMethod(name.Substring(name.IndexOf('.') + 1), "OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            Util.CallMethod(name.Substring(name.IndexOf('.') + 1), "OnClick", go);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null) return;
            if (buttons.ContainsKey(go.name))
            {
                Debug.LogWarning("AddClick:"+go);
                buttons.Remove(go.name);
            }
            buttons.Add(go.name, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }

        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.name, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go.name);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            Util.CallMethod(name.Substring(name.IndexOf('.') + 1), "OnDestroy");
            ClearClick();
#if ASYNC_MODE
            string abName = name.Substring(0, name.IndexOf('.')).ToLower();
            ResManager.UnloadAssetBundle(abName + AppConst.ExtName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}