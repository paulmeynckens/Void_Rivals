using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using RotaryHeart.Lib.SerializableDictionary;
using Core.Interractables;

namespace ShipsLogic.Guns
{
    public class AmmoBox : ItemDeposit
    {

        GameObject currentAmmoStack = null;
        [SerializeField]ShipGunData gunData = null;
        [SerializeField] string requestedItemWhenEmpty = "AB";
        

        public override void ServerEmpty()
        {
            base.ServerEmpty();
            requestedItemType = requestedItemWhenEmpty;

        }


        protected override void ServerFill()
        {
            base.ServerFill();
            itemQuantity = gunData.ammoPerRack;
            requestedItemType = null;

        }

        #region Customisation
        public void ResetGun()
        {

            if (currentAmmoStack != null)
            {
                Destroy(currentAmmoStack);
            }
            givenItemType = null;
            itemQuantity = 0;

        }

        public void SetGun(ShipGunData newGunShape)
        {

            gunData = newGunShape;

            currentAmmoStack = Instantiate(gunData.ammoPrefab, transform);

            givenItemType = gunData.requestedAmmoType;

            maxQuantity = gunData.ammoPerRack;

            if (isServer)
            {
                itemQuantity = maxQuantity;
                //ammoRackFiller.gameObject.SetActive(false);
            }

        }

        #endregion
    }

}


