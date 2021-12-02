using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace Core
{
    public class CustomVisibility : InterestManagement
    {
        

        public override bool OnCheckObserver(NetworkIdentity identity, NetworkConnection newObserver)
        {
            return identity.gameObject.activeInHierarchy;
        }
        public override void OnRebuildObservers(NetworkIdentity identity, HashSet<NetworkConnection> newObservers, bool initialize)
        {
            foreach (NetworkConnectionToClient conn in NetworkServer.connections.Values)
            {
                if (conn != null && conn.identity != null)
                {
                    if (identity.gameObject.activeInHierarchy)
                    {
                        newObservers.Add(conn);
                    }
                    else
                    {
                        newObservers.Remove(conn);
                    }
                    
                }
            }
                
                
                    
                    
            

        }

        [ServerCallback]
        void Update()
        {
            RebuildAll();
        }
    }
}
