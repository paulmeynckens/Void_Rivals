using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GeneralRendering
{
    public class LinkToRenderer : MonoBehaviour
    {
        [SerializeField] Transform generalBody = null;
        [SerializeField] Transform externalCollider = null;
        [SerializeField] Transform internalCollider = null;
        

        public static readonly Dictionary<Transform, Transform> shipsRenderersLinks=new Dictionary<Transform, Transform>();

        private void Awake()
        {

            shipsRenderersLinks.Add(generalBody, transform);
            shipsRenderersLinks.Add(externalCollider, transform);
            shipsRenderersLinks.Add(internalCollider, transform);
        }
    }
}

