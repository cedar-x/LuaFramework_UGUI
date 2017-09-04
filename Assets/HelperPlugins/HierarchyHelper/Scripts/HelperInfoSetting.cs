using UnityEngine;
using System;

namespace HierarchyHelper
{
	public class HelperInfoSetting : Attribute
	{
		public HelperInfoSetting( string category, int priority = 0 )
		{
			this.Category = category;
			this.Priority = priority;
		}

		public HelperInfoSetting( Type type, string category, int priority = 0 )
		{
			this.HelperType = type;
			this.Category = category;
			this.Priority = priority;
		}

        public Type HelperType { get; set; }
        public string Category { get; set; }
        public int Priority { get; set; }
	}
}