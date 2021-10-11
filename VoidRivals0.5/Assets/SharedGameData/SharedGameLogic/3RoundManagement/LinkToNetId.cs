using UnityEngine;
using System.Collections;
using Mirror;
using System;

namespace RoundManagement
{
    public class LinkToNetId : NetworkBehaviour
    {
        public event Action<uint> OnClientLinkEstablished=delegate { };
        [SyncVar(hook = nameof (OnLinkEstablised))] public uint netIdLink = 0;
        
        void OnLinkEstablised(uint _old, uint _new)
        {
            OnClientLinkEstablished(_new);
        }
    }
}