using Mirror;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Core.Interractables;
using Core.ServerAuthoritativeActions;

namespace ShipsLogic.Guns
{
    public class ShipGunMagasine : ItemDeposit
    {
        [SerializeField] short ammoPerItem = 100;
        
        GameObject currentShape = null;

        const int ACTIVABLE_OBJECTS_LAYER = 10;
        const int DEFAULT_LAYER = 0;

        public event Action<short, short> OnAmmoQuantityChanged = delegate { };


        #region Syncvars + hooks
        [SyncVar(hook = nameof(ClientUpdateAmmoVisuals))] short ammo = 0;
        public short Ammo
        {
            get => ammo;
        }

        void ClientUpdateAmmoVisuals(short _old, short _new)
        {
            OnAmmoQuantityChanged(_old, _new);
        }

        #endregion



        #region Server

        public override void OnStartServer()
        {
            base.OnStartServer();

            ammo = (short)(ammoPerItem * itemQuantity);
        }

        protected override void ServerDropObject(NetworkIdentity p_requestingPlayer)
        {
            base.ServerDropObject(p_requestingPlayer);
            ammo = (short)(ammoPerItem * itemQuantity);

        }
        protected override void ServerPickupObject(NetworkIdentity p_requestingPlayer)
        {
            base.ServerPickupObject(p_requestingPlayer);
            ammo = (short)(ammoPerItem * itemQuantity);
        }


        public void ServerConsumeAmmo()
        {
            if (ammo > 0)
            {
                ammo--;
            }

            itemQuantity = (short)Mathf.CeilToInt((float)ammo / (float)ammoPerItem); // Adjust item quantity according to ammo quantity
        }

        protected override bool ServerCanGiveItemToPlayer()
        {
            if((float)ammo/(float)ammoPerItem == (float)itemQuantity) // means the current item has all the ammo in it.
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public override void ServerReset()
        {
            base.ServerReset();
            ammo = (short)(ammoPerItem * itemQuantity);
        }

        #endregion

        #region Customisation

        public void SetGun(ShipGunData newGunData)
        {
            currentShape = Instantiate(newGunData.gunMagasinePrefab, transform);

            //m_renderer = currentShape.GetComponentInChildren<Renderer>();
            itemType = newGunData.requestedAmmoType;

        }

        public void ResetGun()
        {
            if (currentShape != null)
            {
                Destroy(currentShape);
            }

            itemType = null;

        }

        #endregion

    }
}


