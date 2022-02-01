using UnityEngine;
using System.Collections;
using Mirror;
using System;

namespace RoundManagement
{
    public class LinkToNetId : NetworkBehaviour
    {
        public event Action<uint> OnClientLinkEstablished=delegate { };
        [SyncVar(hook = nameof (OnLinkEstablished))] public uint netIdLink = 0;
        
        void OnLinkEstablished(uint _old, uint _new)
        {
            OnClientLinkEstablished(_new);
        }
    }
}