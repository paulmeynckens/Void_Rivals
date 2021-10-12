using System.Collections.Generic;
using Mirror;
using System;

namespace Core
{
    public class CustomNetworkManager : NetworkManager
    {
        public static event Action<uint> OnPlayerDisconnect;



        #region Server

        public override void OnStartServer()
        {
            base.OnStartServer();
            ServerChangeScene(onlineScene);
        }

        /// <summary>
        /// prevents the server from destroying the object controlled by the player
        /// </summary>
        /// <param name="conn"></param>
        public override void OnServerDisconnect(NetworkConnection conn)
        {
            OnPlayerDisconnect?.Invoke(conn.identity.netId);


            List<NetworkIdentity> foundNetIdents = new List<NetworkIdentity>();
            foreach (NetworkIdentity identity in conn.clientOwnedObjects)
            {
                if (identity != conn.identity)
                {
                    foundNetIdents.Add(identity);
                }


            }

            foreach (NetworkIdentity netId in foundNetIdents)
            {
                netId.RemoveClientAuthority();
            }



            base.OnServerDisconnect(conn);
        }


        #endregion




    }
}





