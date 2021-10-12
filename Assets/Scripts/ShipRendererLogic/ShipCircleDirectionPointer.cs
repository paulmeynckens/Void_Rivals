using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;
using Core;


namespace ShipsRenderer
{
    public class ShipCircleDirectionPointer : MonoBehaviour
    {

        [SerializeField] Transform arrow = null;

        ShipController shipController=null;

        private void Awake()
        {
            shipController = GetComponentInParent<ShipController>();
        }


        void LateUpdate()
        {

            if (!shipController.hasAuthority || Input.GetKey(KeyBindings.Pairs[Actions.aim]))
            {
                arrow.gameObject.SetActive(false);
                return;
            }
            arrow.gameObject.SetActive(true);

            arrow.localPosition = shipController.pullController.CurrentInput*MousePullController.maxSize;

            float angle = Mathf.Atan2(arrow.localPosition.y, arrow.localPosition.x) * Mathf.Rad2Deg;

            arrow.localRotation = Quaternion.AngleAxis(angle, Vector3.forward);


        }


    }
}

