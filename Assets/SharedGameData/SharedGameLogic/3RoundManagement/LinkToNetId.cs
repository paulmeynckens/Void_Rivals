﻿using UnityEngine;
using System.Collections;
using Mirror;
using System;

namespace RoundManagement
{
    public class LinkToNetId : NetworkBehaviour
    {
        public event Action<NetworkIdentity> OnClientLinkEstablished=delegate { };


        [SyncVar(hook = nameof (OnLinkEstablished))] public uint netIdLink = 0;
        
        void OnLinkEstablished(uint _old, uint _new)
        {
            StartCoroutine(EstablishLink(_new));
            
        }

        IEnumerator EstablishLink(uint netId)
        {
            if (NetworkIdentity.spawned.ContainsKey(netId))
            {
                OnClientLinkEstablished(NetworkIdentity.spawned[netId]);
            }
            else
            {
                yield return null;
            }



            

        }
    }
}