using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace Core
{
    public class CustomVisibility : InterestManagement
    {
        
        public static readonly Dictionary<NetworkIdentity, bool> globalVisibilities = new Dictionary<NetworkIdentity, bool>();

        public override bool OnCheckObserver(NetworkIdentity identity, NetworkConnection newObserver)
        {
            if (!globalVisibilities.ContainsKey(identity))
            {
                return true;
            }
            else
            {
                return globalVisibilities[identity];
            }
        }
        public override void OnRebuildObservers(NetworkIdentity identity, HashSet<NetworkConnection> newObservers, bool initialize)
        {
            foreach (NetworkConnectionToClient conn in NetworkServer.connections.Values)
            {
                if (conn != null && conn.identity != null)
                {
                    if (!globalVisibilities.ContainsKey(identity))
                    {
                        newObservers.Add(conn);
                    }
                    else if(globalVisibilities[identity])
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
