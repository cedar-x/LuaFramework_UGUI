using UnityEngine;
using System;

namespace HierarchyHelper
{
	public class HelperInfoAttribute : Attribute
	{
		public HelperInfoAttribute( string category, int priority = 0 )
		{
			this.Category = category;
			this.Priority = priority;
		}

		public HelperInfoAttribute( Type type, string category, int priority = 0 )
		{
			this.HelperType = type;
			this.Category = category;
			this.Priority = priority;
		}
        public Type HelperType{ get; set; }
        public string Category { get; set; }
        public int Priority { get; set; }
	}
}