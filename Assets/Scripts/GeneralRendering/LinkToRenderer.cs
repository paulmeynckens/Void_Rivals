using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace GeneralRendering
{
    public class LinkToRenderer : MonoBehaviour
    {
        
        [SerializeField] List<NetworkIdentity> linkedToThisRenderer = null;

        public static readonly Dictionary<NetworkIdentity, Transform> linkedRenderer=new Dictionary<NetworkIdentity, Transform>();

        private void Awake()
        {
            foreach(NetworkIdentity networkIdentity in linkedToThisRenderer)
            {
                linkedRenderer.Add(networkIdentity, transform);
            }
        }
    }
}

