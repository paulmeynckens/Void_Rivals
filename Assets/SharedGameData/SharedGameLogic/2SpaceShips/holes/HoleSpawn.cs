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
        public event Action<Transform,Vector3,Quaternion> OnHolePlaced = delegate { };
        [SyncVar(hook =nameof (ClientPlaceHole))] HoleSpot positionRotation ;
        

        void ClientPlaceHole(HoleSpot _old, HoleSpot _new)
        {
            transform.parent = BodiesHolder.interiors[NetworkIdentity.spawned[_new.holeGeneratorIdentity]];
            transform.localPosition = _new.localPosition;
            transform.localRotation = _new.localRotation;
            OnHolePlaced(transform.parent,_new.localPosition,_new.localRotation);
        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            positionRotation = new HoleSpot { holeGeneratorIdentity = BodiesHolder.interiorsId[transform.parent].netId, localPosition = transform.localPosition, localRotation = transform.localRotation };
        }

        
    }
}
