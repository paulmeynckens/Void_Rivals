using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;
using Core;
using UnityEngine.UI;


namespace ShipsRenderer
{
    public class ShipCircleDirectionPointer : MonoBehaviour
    {

        ShipController shipController=null;
        [SerializeField] Image[] images = null;

        private void Start()
        {
            ShipController.OnClientTakeControl += SetupShipController;
            ShipController.OnClientExit += DeactivatePointer;

            DeactivatePointer();
        }

        void SetupShipController(ShipController p_shipController)
        {
            
            shipController = p_shipController;
            
            
        }
        void DeactivatePointer()
        {
            shipController = null;
        }

        void LateUpdate()
        {
            /*
            if (Input.GetKey(KeyBindings.Pairs[Actions.aim]))
            {
                gameObject.SetActive(false);
                return;
            }
            gameObject.SetActive(true);
            */

            foreach (Image image in images)
            {
                image.enabled = shipController!=null;
            }
            if (shipController == null || !shipController.hasAuthority)
            {
                return;
            }

            transform.localPosition = shipController.pullController.CurrentInput*MousePullController.maxSize;

            float angle = Mathf.Atan2(transform.localPosition.y, transform.localPosition.x) * Mathf.Rad2Deg;

            transform.localRotation = Quaternion.AngleAxis(angle, Vector3.forward);


        }


    }
}

