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


        private void Awake()
        {
            ammoIndicator.text = "No ammo";
            gunMagasine.OnAmmoQuantityChanged += ChangeIndicatorValue;            
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


