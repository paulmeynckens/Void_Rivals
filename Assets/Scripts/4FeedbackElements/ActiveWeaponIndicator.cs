using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Guns;

namespace FeedbackElements
{
    public class ActiveWeaponIndicator : MonoBehaviour
    {
        [SerializeField] ShipGun shipGun=null;
        [SerializeField] GameObject activeAmmoIndicator = null;
        // Update is called once per frame
        void FixedUpdate()
        {
            activeAmmoIndicator.SetActive(shipGun.enabled);
        }
    }
}
