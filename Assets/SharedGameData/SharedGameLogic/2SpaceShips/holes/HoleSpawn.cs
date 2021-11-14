using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;

namespace ShipsLogic.Holes
{
    public class HoleSpawn : NetworkBehaviour
    {
        public event Action<NetworkIdentity,Vector3,Quaternion> OnHolePlaced = delegate { };
        [SyncVar(hook =nameof (ClientPlaceHole))] HoleSpot positionRotation ;
        

        void ClientPlaceHole(HoleSpot _old, HoleSpot _new)
        {
            
            transform.parent = _new.holeGeneratorIdentity.transform;
            transform.localPosition = _new.localPosition;
            transform.localRotation = _new.localRotation;
            OnHolePlaced( _new.holeGeneratorIdentity,_new.localPosition,_new.localRotation);
        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            positionRotation = new HoleSpot { holeGeneratorIdentity = transform.parent.GetComponent<NetworkIdentity>(), localPosition = transform.localPosition, localRotation = transform.localRotation };
        }

        
    }
}
