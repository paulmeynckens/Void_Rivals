using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;
using Core.Interractables;
using Core.ServerAuthoritativeActions;

namespace ShipsLogic.Guns
{
    public class ShipGun : ServerAuthoritativeGun
    {

        [SerializeField] ShipGunMagasine gunMagasine = null;


        GameObject currentGun = null;

        Renderer ownRenderer;

        protected override bool CanShoot()
        {
            if(base.CanShoot()&& gunMagasine.Ammo > 0)
            {
                return true;
            }
            else
            {
                return false;
            }

        }


        protected override void ServerConsumeAmmo()
        {
            base.ServerConsumeAmmo();
            gunMagasine.ServerConsumeAmmo();
        }



        #region customisation
        public void ResetGun()
        {

            data = null;

            //maxEnergyFlux = 0;

            ownRenderer.enabled = true;

            if (isServer)
            {
                currentMagasineLoad = 0;
            }

            if (currentGun != null)
            {
                Destroy(currentGun);
            }

        }


        public void SetGun(ShipGunData newGunData)
        {
            data = newGunData;
            //maxEnergyFlux = gunData.requiredEnergyFlux;
            currentGun = Instantiate(newGunData.gunPrefab, transform);

            ownRenderer.enabled = false;
        }

        #endregion



    }
}

