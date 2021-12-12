using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GeneralRendering
{
    public class LinkToRenderer : MonoBehaviour
    {
        [SerializeField] Transform internalCollider = null;
        [SerializeField] Transform externalCollider = null;

        public static readonly Dictionary<Transform, Transform> shipsRenderersLinks=new Dictionary<Transform, Transform>();

        private void Awake()
        {

            shipsRenderersLinks.Add(internalCollider, transform);
            shipsRenderersLinks.Add(externalCollider, transform);
        }
    }
}

