using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Reflection;
using System.Linq;

namespace HierarchyHelper
{
	public class HierarchyHelperSettingWindow : EditorWindow
	{
        const string MENU_PATH_SETTING_WINDOW = "Tools/HierarchyHelper";
        const string MENU_CLEAR_MISSING_SCRIPT = "Tools/Clear MissScript";
		const string MENU_PATH_ENABLED = "Tools/HierarchyHelper/Enabled";

		private static Dictionary<HelperInfoSetting,MethodInfo> _methodMap = null;
		private static Dictionary<string,List<HelperInfoSetting>> _priorityMap = null;

        [MenuItem(MENU_PATH_SETTING_WINDOW, false, 1)]
        public static void Create()
        {
            HierarchyHelperSettingWindow t = GetWindow<HierarchyHelperSettingWindow>("Hierarchy Helper");
            t.Show();
        }

        [MenuItem(MENU_CLEAR_MISSING_SCRIPT, false, 2)]
        static void CleanupMissingScripts()
        {
            for (int i = 0; i < Selection.gameObjects.Length; i++)
            {
                var gameObject = Selection.gameObjects[i];

                // We must use the GetComponents array to actually detect missing components
                var components = gameObject.GetComponents<Component>();

                // Create a serialized object so that we can edit the component list
                var serializedObject = new SerializedObject(gameObject);
                // Find the component list property
                var prop = serializedObject.FindProperty("m_Component");

                // Track how many components we've removed
                int r = 0;

                // Iterate over all components
                for (int j = 0; j < components.Length; j++)
                {
                    // Check if the ref is null
                    if (components[j] == null)
                    {
                        // If so, remove from the serialized component array
                        prop.DeleteArrayElementAtIndex(j - r);
                        // Increment removed count
                        r++;
                    }
                }

                // Apply our changes to the game object
                serializedObject.ApplyModifiedProperties();
                //这一行一定要加！！！
                EditorUtility.SetDirty(gameObject);
            }
        }

		void OnEnable()
		{
			_priorityMap = new Dictionary<string, List<HelperInfoSetting>>();
			_methodMap = new Dictionary<HelperInfoSetting, MethodInfo>();

			List<MethodInfo> methods = HierarchyHelperManager.FindMethodsWithAttribute<HelperInfoSetting>().ToList();
			foreach( MethodInfo m in methods )
			{
				object[] objs = m.GetCustomAttributes( typeof( HelperInfoSetting ), true );
				foreach( object obj in objs )
				{
					HelperInfoSetting attr = obj as HelperInfoSetting;
					if( !_priorityMap.ContainsKey( attr.Category ) )
						_priorityMap[attr.Category] = new List<HelperInfoSetting>();
					_priorityMap[attr.Category].Add( attr );

					_methodMap[attr] = m;
				}
			}

			foreach( List<HelperInfoSetting> list in _priorityMap.Values )
			{
				list.Sort( delegate(HelperInfoSetting x, HelperInfoSetting y) {
					return x.Priority.CompareTo( y.Priority );
				});
			}
		}

		Vector2 _scrollPosition = Vector2.zero;
		void OnGUI()
		{
			GUI.changed = false;

			EditorGUILayout.Space();
			HierarchyHelperManager.Showing = EditorGUILayout.ToggleLeft( "Enable Helper System", HierarchyHelperManager.Showing );

			EditorGUI.BeginDisabledGroup( !HierarchyHelperManager.Showing );
			{
				HierarchyHelperManager.PreservedWidth = EditorGUILayout.IntSlider( "Preserved Width", HierarchyHelperManager.PreservedWidth, 100, 500 );
				HierarchyHelperManager.Spacing = EditorGUILayout.IntSlider( "Spacing", HierarchyHelperManager.Spacing, 0, 10 );
				EditorGUILayout.Space();

				EditorGUILayout.BeginHorizontal();
				{
					GUILayout.Label( "No.", GUILayout.Width( 40f ) );
					GUILayout.Label( "Count", GUILayout.Width( 40f ) );

					EditorGUILayout.LabelField( "Categroy", "Showing" );
				}
				EditorGUILayout.EndHorizontal();

				_scrollPosition = EditorGUILayout.BeginScrollView( _scrollPosition );

				int i=1;
				foreach( string c in HierarchyHelperManager.Categroies.Keys )
				{
					EditorGUILayout.BeginHorizontal();
					{
						GUILayout.Label( i++.ToString(), GUILayout.Width( 40f ) );
						GUILayout.Label( HierarchyHelperManager.Categroies[c].attrnum.ToString(), GUILayout.Width( 40f ) );

						bool isOn = HierarchyHelperManager.GetShowing( c );
                        bool tempOn = EditorGUILayout.Toggle(c + "(" + HierarchyHelperManager.Categroies[c].priority.ToString() + ")", isOn);
						if( isOn != tempOn )
						{
                            HierarchyHelperManager.SetShowing(c, tempOn);
						}

						if( _priorityMap.ContainsKey( c ) )
						{
							foreach( HelperInfoSetting setting in _priorityMap[c] )
							{
								_methodMap[setting].Invoke( null, null );
							}
						}
					}
					EditorGUILayout.EndHorizontal();
				}
			}
			EditorGUI.EndDisabledGroup();
			EditorGUILayout.EndScrollView();

			if( GUI.changed )
				EditorApplication.RepaintHierarchyWindow();
		}
	}
}
