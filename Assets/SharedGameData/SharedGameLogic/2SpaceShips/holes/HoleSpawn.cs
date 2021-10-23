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
        public event Action OnHolePlaced = delegate { };
        [SyncVar(hook =nameof (ClientPlaceHole))] HoleSpot positionRotation = new HoleSpot  { holeGeneratorIdentity=0, localPosition = Vector3.zero, localRotation=Quaternion.identity };
        

        void ClientPlaceHole(HoleSpot _old, HoleSpot _new)
        {
            transform.parent = BodiesHolder.interiors[NetworkIdentity.spawned[_new.holeGeneratorIdentity]];
            transform.localPosition = _new.localPosition;
            transform.localRotation = _new.localRotation;
            OnHolePlaced();
        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            positionRotation = new HoleSpot { holeGeneratorIdentity = BodiesHolder.interiorsId[transform.parent].netId, localPosition = transform.localPosition, localRotation = transform.localRotation };
        }

        
    }
}
