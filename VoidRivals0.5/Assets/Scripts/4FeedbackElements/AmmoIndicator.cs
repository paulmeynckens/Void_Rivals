using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Core;

namespace FeedbackElements
{
    public class AmmoIndicator : MonoBehaviour
    {
        [SerializeField] MonoBehaviour gun = null;




        [SerializeField] TMP_Text ammoIndicator = null;


        private void Awake()
        {
            if (gun is IChangeQuantity iChangeQuantity)
            {
                iChangeQuantity.OnChangeQuantity += ChangeIndicatorValue;
            }

            ammoIndicator.text = "No ammo";
        }

        void ChangeIndicatorValue(short value, short maxValue)
        {
            if (value == 0)
            {
                ammoIndicator.text = "No ammo";
            }
            else
            {
                ammoIndicator.text = value.ToString();
            }

        }

    }
}


