using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CharacterRenderer
{
    public class LinkToRenderer : MonoBehaviour
    {
        [SerializeField] Transform shipInternalCollider = null;
        [SerializeField] Transform shipExternalCollider = null;

        public static Dictionary<Transform, Transform> shipsRenderersLinks;

        private void Awake()
        {
            if (shipsRenderersLinks == null)
            {
                shipsRenderersLinks = new Dictionary<Transform, Transform>();
            }
            shipsRenderersLinks.Add(shipInternalCollider, transform);
            shipsRenderersLinks.Add(shipExternalCollider, transform);
        }
    }
}

