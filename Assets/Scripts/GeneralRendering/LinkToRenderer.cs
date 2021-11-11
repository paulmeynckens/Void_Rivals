using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GeneralRendering
{
    public class LinkToRenderer : MonoBehaviour
    {

        [SerializeField] Transform shipExternalCollider = null;

        public static readonly Dictionary<Transform, Transform> shipsRenderersLinks=new Dictionary<Transform, Transform>();

        private void Awake()
        {

            shipsRenderersLinks.Add(transform.parent, transform);
            shipsRenderersLinks.Add(shipExternalCollider, transform);
        }
    }
}

