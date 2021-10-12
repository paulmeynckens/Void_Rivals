using System.Collections;
using System.Collections.Generic;
using Core;
using UnityEngine;
using ShipsLogic;

namespace ShipsRenderer
{
    public class ShipViewRotation : MonoBehaviour
    {
        [SerializeField] TwoAxisRotator cameraRotator = null;
        ShipController shipController;
        private void Awake()
        {
            shipController = GetComponentInParent<ShipController>();
        }

        // Update is called once per frame
        void Update()
        {
            if (shipController.hasAuthority && shipController.shipData.shipType==ShipType.strike_craft)
            {
                if (Input.GetKey(KeyBindings.Pairs[Actions.aim]))
                {
                    cameraRotator.RotateView();
                }
                else
                {
                    cameraRotator.GentlySnapForward();
                }
            }
            
        }
    }
}
