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

        protected override bool ServerCanUseObjectClick(NetworkIdentity requestingPlayer)
        {

            ICanGrabItem canGrabItem = requestingPlayer.GetComponent<ICanGrabItem>();
            if (canGrabItem.HeldItemType == requestedTool)
            {
                return true;
            }
            return false;
        }

        protected override void ServerUseObjectClick(NetworkIdentity requestingPlayer)
        {
            base.ServerUseObjectClick(requestingPlayer);
            damage -= HOLE_REPAIR_RATE;
            if (damage <= 0)
            {
                damage = 0;
                OnServerHoleRepair(this);
            }


        }

    }
}



