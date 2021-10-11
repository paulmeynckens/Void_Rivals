using Mirror;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Core.Interractables;
using Core.ServerAuthoritativeActions;

namespace ShipsLogic.Guns
{
    public class GunMagasine : ItemDeposit
    {

        [SerializeField] SpaceShipGun shipGun = null;

        GameObject currentShape = null;

        const int ACTIVABLE_OBJECTS_LAYER = 10;
        const int DEFAULT_LAYER = 0;

        


        protected override void ServerFill()
        {
            base.ServerFill();

            

            shipGun.ServerReload();

        }




        #region Customisation

        public void SetGun(ShipGunData newGunData)
        {
            currentShape = Instantiate(newGunData.gunMagasinePrefab, transform);

            //m_renderer = currentShape.GetComponentInChildren<Renderer>();
            requestedItemType = newGunData.requestedAmmoType;

        }

        public void ResetGun()
        {
            if (currentShape != null)
            {
                Destroy(currentShape);
            }

            requestedItemType = null;

        }

        #endregion

    }
}


