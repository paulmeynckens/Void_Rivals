using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;
using Core.Interractables;

namespace ShipsLogic.Holes

{
    public class Hole :Interractable
    {
        [SerializeField] string requestedTool="RT";
        [SerializeField] SphereCollider sphereCollider = null;

        const short HOLE_REPAIR_RATE = 3;
        public short Damage
        {
            get => damage;
            set=> damage = value;
        }
        
        [SyncVar]short damage = 0;


        public event Action<Hole> OnServerHoleRepair=delegate { };

        private void Start()
        {
            sphereCollider.radius = Structure.ConvertDamageToRadius(damage);
            Debug.Log("poping hole");
        }

        protected override bool ServerCanUseObjectE(NetworkIdentity requestingPlayer)
        {

            ICanGrabItem canGrabItem = requestingPlayer.GetComponent<ICanGrabItem>();
            if (canGrabItem.HeldItemType == requestedTool)
            {
                return true;
            }
            return false;
        }

        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            base.ServerUseObjectE(requestingPlayer);
            damage -= HOLE_REPAIR_RATE;
            if (damage <= 0)
            {
                damage = 0;
                OnServerHoleRepair(this);
            }


        }

    }
}



