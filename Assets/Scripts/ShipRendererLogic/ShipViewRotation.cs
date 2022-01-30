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
        [SerializeField] ShipController shipController;

        // Update is called once per frame
        void Update()
        {
            if (shipController.hasAuthority)
            {
                if (Input.GetKey(KeyBindings.Pairs[PlayerAction.aim]))
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
