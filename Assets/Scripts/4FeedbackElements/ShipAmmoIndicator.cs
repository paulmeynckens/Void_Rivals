using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Core;
using Core.ServerAuthoritativeActions;
using ShipsLogic.Guns;

namespace FeedbackElements
{
    public class ShipAmmoIndicator : MonoBehaviour
    {
        [SerializeField] ShipGunMagasine gunMagasine = null;

        [SerializeField] TMP_Text ammoIndicator = null;



        private void Start()
        {
            gunMagasine.OnAmmoQuantityChanged += ChangeIndicatorValue;
            ammoIndicator.text = gunMagasine.Ammo.ToString();
        }

        void ChangeIndicatorValue(short _old, short _new)
        {
            if (_new == 0)
            {
                ammoIndicator.text = "No ammo";
            }
            else
            {
                ammoIndicator.text = _new.ToString();
            }

        }

    }
}


