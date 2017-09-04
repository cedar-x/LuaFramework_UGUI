using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using HierarchyHelper;

public static class ExternTransform{
    public static Transform TreeFind(this Transform trans, string childName)
    {
        TreeTransform treeTrans = trans.GetComponent<TreeTransform>();
        if (treeTrans == null) return null;
        int index = childName.IndexOf('/');
        if (index == -1)
            return treeTrans.FindChild(childName);
        string firstName = childName.Substring(0,index);
        string secName = childName.Substring(index+1);
        Transform child = treeTrans.FindChild(firstName);
        return child.TreeFind(secName);
    }
}
public class TreeTransform : MonoBehaviour
{
    public Transform[] childs = new Transform[0];
    private HashSet<Transform> _cache = new HashSet<Transform>();

#if UNITY_EDITOR
    private static GUIContent _checktip;
    private static GUIContent _multitip;
    private static GUIContent _subtip;
    private static GUIContent _addtip;
    [HelperInfoAttribute("TreeTransform", 110)]
    public static void DrawHelper( GameObject obj )
    {
        if (_checktip == null)
        {
            _checktip = new GUIContent(string.Empty, "Check Multi be Same");
            _multitip = new GUIContent(string.Empty, "Multi TreeTransform");
            _subtip = new GUIContent(string.Empty, "Sub From TreeTransform");
            _addtip = new GUIContent(string.Empty, "Add To TreeTransform");
        }
        Rect rect = HierarchyHelperManager.GetControlRect(8f);
        rect.y += 3;
        rect.height -= 6;

        TreeTransform mine = obj.GetComponentInParent<TreeTransform>();
        int num = 0;
        if (mine == null){
            return;
        }
        else if (mine.gameObject == obj)
        {
            num = mine.CheckMulti();
            HierarchyHelperTools.DrawWithColor(num==2?Color.yellow:(num==1?Color.red:Color.green), () =>
            {
                GUI.DrawTexture(rect, HierarchyHelperTools.WhiteTexture, ScaleMode.StretchToFill, true);
                GUI.Label(rect, _checktip);
            });
            return;
        }
        num = mine.CheckChild(obj.transform);
        Color color = num == 0 ? Color.white : (num == 1 ? Color.green : Color.red);
        if (GUI.Button(rect, "", "label"))
        {
            if (num == 0)
                mine.AddChild(obj.transform);
            else
                mine.SubChild(obj.transform);
        }
        HierarchyHelperTools.DrawWithColor(color, () => {
            GUI.Label(rect, num == 0 ? _addtip : (num == 1 ? _subtip : _multitip));
            rect.y += 4;
            rect.height -= 8;
            GUI.DrawTexture(rect, HierarchyHelperTools.WhiteTexture, ScaleMode.StretchToFill, true);
            if (num==0){
                rect.y -= 4;
                rect.x += 3;
                rect.height += 8;
                rect.width -= 6;
                GUI.DrawTexture(rect, HierarchyHelperTools.WhiteTexture, ScaleMode.StretchToFill, true);
            }
            
        });
    }
#endif
    public int childCount
    {
        get
        {
            return childs.Length;
        }
    }
    public bool hasChildren
    {
        get {
            return childCount > 0;
        }
    }
    public Transform GetChild(int index)
    {
        return childs[index];
    }
    public Transform FindChild(string childName)
    {
        for (int i = 0, len = childs.Length; i < len; i++)
        {
            if (childs[i].name.Equals(childName))
            {
                return childs[i];
            }
        }
        return null;
    }
    private int CheckChild(Transform child)
    {
        int num = 0;
        for (int i = 0, len = childs.Length; i < len; i++)
        {
            if (childs[i] == child)
            {
                num++;
            }
        }
        return num;
    }
    private int CheckMulti()
    {
        _cache.Clear();
        for (int i = 0, len = childs.Length; i < len; i++)
        {
            Transform child = childs[i];
            if (child == null)
                return 1;
            if (_cache.Contains(child))
            {
                return 2;
            }
            _cache.Add(child);
        }
        return 0;
    }
    private void AddChild(Transform child)
    {
        int num = childCount;
        Array.Resize(ref this.childs, num + 1);
        this.childs.SetValue(child, num);
    }
    private void SubChild(Transform child)
    {
        for (int i = 0, len = childs.Length; i < len; i++)
        {
            if (childs[i] == child)
            {
                Array.Copy(childs, i + 1, childs, i, len - i - 1);
                Array.Resize(ref childs, len - 1);
                return;
            }
        }
    }
    
}
