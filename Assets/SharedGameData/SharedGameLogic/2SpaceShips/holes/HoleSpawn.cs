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
        public event Action<HoleSpot> OnHolePlaced = delegate { };
        [SyncVar(hook =nameof (ClientPlaceHole))] HoleSpot positionRotation ;
        public NetworkIdentity Hull
        {
            
            set
            {
                hull = value;
                positionRotation = new HoleSpot { holeGeneratorIdentity = hull, localPosition = transform.localPosition, localRotation = transform.localRotation };
            }
        }
        NetworkIdentity hull = null;
        
        void ClientPlaceHole(HoleSpot _old, HoleSpot _new)
        {
            
            transform.parent = _new.holeGeneratorIdentity.transform;
            transform.localPosition = _new.localPosition;
            transform.localRotation = _new.localRotation;
            OnHolePlaced(_new);
        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            
        }

        
    }

    public struct HoleSpot
    {
        public NetworkIdentity holeGeneratorIdentity;
        public Vector3 localPosition;
        public Quaternion localRotation;

    }
}
