using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace LuaFramework {

    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour {

        void Awake()
        {
            Canvas canvasPanel = GameObject.FindObjectOfType<Canvas>();
            if (canvasPanel == null)
            {
                Debug.LogError("Scene Can't Find UGUI Canvas");
                return;
            }
            EventSystem eventSystem = GameObject.FindObjectOfType<EventSystem>();
            if (eventSystem == null)
            {
                Debug.LogError("Scene Can't Find UGUI EventSystem");
                return;
            }
            GameObject guiCamera = GameObject.FindGameObjectWithTag("GuiCamera");
            if (guiCamera == null)
            {
                Debug.LogError("Scene Can't Find Tag GuiCamera");
                return;
            }
            DontDestroyOnLoad(canvasPanel.gameObject);
            DontDestroyOnLoad(eventSystem.gameObject);
        }
        void Start() {
            AppFacade.Instance.StartUp();   //启动游戏
        }
    }
}