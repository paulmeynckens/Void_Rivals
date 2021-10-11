using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using Mirror;

namespace CharacterLogic
{
    public class CharacterLocal : NetworkBehaviour
    {
        public static NetworkIdentity localCharacter=null;
        public static event Action<NetworkIdentity> OnLocalCharacterSet = delegate { };

        public override void OnStartAuthority()
        {
            base.OnStartAuthority();
            OnLocalCharacterSet(netIdentity);
            localCharacter = netIdentity;
        }
        private void OnDestroy()
        {
            localCharacter = null;
        }
    }
}
