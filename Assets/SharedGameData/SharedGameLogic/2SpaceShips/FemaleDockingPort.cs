using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.Interractables;
using System;
using Core;

namespace ShipsLogic
{
    public class FemaleDockingPort : NetworkBehaviour,IResettable
    {
        public Transform FemaleNonMovingBody 
        { 
            get => femaleNonMovingBody; 
            
        }

        [SerializeField] Transform femaleNonMovingBody = null;

        

        public GameObject DoorCollider { get => doorCollider; }

        [SerializeField] GameObject doorCollider = null;

        public bool IsAvailable
        {
            get => isAvailable;
            set => isAvailable = value;
        }
        

        [SyncVar] bool isAvailable = true;

        

        void IResettable.ServerReset()
        {
            
            isAvailable = true;
        }
    }
}
