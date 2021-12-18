using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Audio;
using Mirror;

namespace Core.Interractables
{
    public class DoorSwitch : Interractable
    {
        


        [SerializeField] BoxCollider doorBoxCollider = null;
        public event Action<bool> OnDoorChangeState = delegate { };


        [SyncVar(hook = nameof(ClientUpdateDoorState))] bool open = false;

        void ClientUpdateDoorState(bool _old, bool _new)
        {
            OnDoorChangeState(_new);
            doorBoxCollider.enabled = !_new;
        }


        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            ServerSwitch();
        }

        void ServerSwitch()
        {
            open = !open;
            doorBoxCollider.enabled = !open;

        }

        public override void ServerReset()
        {
            open = false;
            doorBoxCollider.enabled = true;
        }


    }
}

