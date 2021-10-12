using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace PoloGames
{
    public class CleanupRenderers : NetworkBehaviour
    {
        [SerializeField] GameObject rendererToRemove = null;

        public override void OnStartServer()
        {
            base.OnStartServer();
            if (!isClient)
            {
                Destroy(rendererToRemove);
            }
        }
    }
}
