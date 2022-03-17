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

        #endregion




    }
}





